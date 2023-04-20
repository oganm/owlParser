


get_file = function(f,memoised = TRUE){
    if(is.character(memoised)){
        cache = memoised
    } else {
        cache = rappdirs::user_cache_dir(appname ='owlParser')
    }
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





clear_cache = function(){
    unlink(rappdirs::user_cache_dir(appname ='owlParser'),recursive = TRUE)
}


