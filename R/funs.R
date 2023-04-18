# get elements of distinct types, grouping them together for easier processing
#' @export
get_elements = function(parent){
    children <- xml2::xml_children(parent)
    children_types <- xml2::xml_name(children)

    elements <- children_types %>% unique %>%  lapply(function(x){
        children[children_types == x]
    })

    names(elements) <- children_types %>% unique
    class(elements) <- append(class(elements),'elements')
    return(elements)
}


get_file = function(f,memoised = TRUE){
    cache = rappdirs::user_cache_dir(appname ='owlParser')
    file = file.path(cache,make.names(f))
    if(file.exists(f) || memoised == FALSE){
        onto = tryCatch(xml2::read_xml(f),error = function(e){
            NULL
        })
    } else if(memoised && !file.exists(file)){
        cache = rappdirs::user_cache_dir(appname ='owlParser')
        dir.create(cache,showWarnings = FALSE)

        download.file(f,destfile = file)
        onto = tryCatch(xml2::read_xml(file),error = function(e){
            NULL
        })
    } else{
        onto = tryCatch(xml2::read_xml(file),error = function(e){
            NULL
        })
    }

    if (is.null(onto)){
        return(NULL)
    }
    return(onto)
}

get_file_elements = function(f,memoised = TRUE){
    onto = get_file(f,memoised)
    get_elements(onto)
}


get_onto_imports = function(onto,env,memoised = TRUE){

    imported_elements = onto$imports[!onto$imports %in% env$uris] %>% lapply(function(x){
        get_file_elements(x,memoised = memoised)
    })
    names(imported_elements) = onto$imports[!onto$imports %in% env$uris]


    env$uris = c(env$uris,onto$imports)


    recursive_imports = imported_elements %>% lapply(function(x){
        get_onto_imports(process_ontology(x$Ontology),env = env,memoised = memoised)
    }) %>% unname %>%  unlist( recursive = FALSE)
    c(imported_elements,recursive_imports)
}


process_ontology = function(onto_xml){
    ontology_elements <- get_elements(onto_xml)
    ontology =
        list(ontologyIRI = onto_xml %>% xml2::xml_attr('about'),
             versionIRI = ontology_elements$versionIRI %>% xml2::xml_attr('resource'),
             version = ontology_elements$versionInfo %>% xml2::xml_contents() %>% as.character(),
             title = ontology_elements$title %>% xml2::xml_contents() %>% as.character(),
             description = ontology_elements$description %>% xml2::xml_contents() %>% as.character(),
             roots = ontology_elements$IAO_0000700 %>% xml2::xml_attr('resource'),
             imports =
                 ontology_elements$imports %>% xml2::xml_attr('resource'),
             default_namespace = ontology_elements$`default-namespace` %>% xml2::xml_contents() %>% as.character()
        )

    return(ontology)
}


clear_cache = function(){
    unlink(rappdirs::user_cache_dir(appname ='owlParser'),recursive = TRUE)
}

# returns an empty nodeset if an empty subset is accessed so failures happen
# gracefully
#' @export
"$.elements" = function(x,y){
    x[[y]]
}

#' @export
"[[.elements" = function(x,y){
    class(x) = 'list'
    out<- x[[y]]
    if(is.null(out)){
        return(structure(list(), class = "xml_nodeset"))
    } else{
        return(out)
    }
}

