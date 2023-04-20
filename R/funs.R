


get_file = function(f,cache = TRUE){
    if(is.character(memoised)){
        cache_path = cache
    } else {
        cache_path = rappdirs::user_cache_dir(appname ='owlParser')
    }
    file = file.path(cache_path,make.names(f))
    if(file.exists(f) || cache == FALSE){
        onto = tryCatch(xml2::read_xml(f),error = function(e){
            NULL
        })
    } else if(cache && !file.exists(file)){
        cache_path = rappdirs::user_cache_dir(appname ='owlParser')
        dir.create(cache_path,showWarnings = FALSE)

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

get_file_elements = function(f,cache = TRUE){
    onto = get_file(f,cache)
    get_elements(onto)
}


get_onto_imports = function(onto,cache = TRUE){
    # a record is kept of previously imported files to avoid loops
    record = new.env()
    record$uris = c()
    onto %>%
        purrr::map(single_onto_imports,env = record,cache = cache) %>%
        unlist(recursive = FALSE)
}

single_onto_imports = function(onto,env,cache = TRUE){

    imported_elements = onto$imports[!onto$imports %in% env$uris] %>% lapply(function(x){
        get_file_elements(x,cache = cache)
    })
    names(imported_elements) = onto$imports[!onto$imports %in% env$uris]


    env$uris = c(env$uris,onto$imports)


    recursive_imports = imported_elements %>% lapply(function(x){
        single_onto_imports(process_ontology(x$Ontology),env = env,cache = cache)
    }) %>% unname %>%  unlist( recursive = FALSE)
    c(imported_elements,recursive_imports)
}





clear_cache = function(){
    unlink(rappdirs::user_cache_dir(appname ='owlParser'),recursive = TRUE)
}


