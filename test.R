library(ontologyIndex)

doid_obo = ontologyIndex::get_ontology("data-raw/obo/doid")
cl_obo = ontologyIndexOgfork::get_ontology('data-raw/obo/cl')



ontology_owls %>% lapply(\(x){
    print(x)
    onto = tryCatch(xml2::read_xml(owl),error = function(e){
        NULL
    })
    if (is.null(onto)){
        return(NULL)
    }

    owl_elements <- get_elements(onto)

    owl_elements$Ontology %>% lapply(function(x){
        ontology_elements <- get_elements(x)
        print(names(ontology_elements))
    })
})

x = 'doid'
f= 'http://purl.obolibrary.org/obo/doid/obo/ext.owl'

names(ontology_owls) %>% lapply(\(x){
    f = file.path('data-raw/owl/',x)

    owl_elements <- get_file_elements(f)


    ontologies <- owl_elements$Ontology %>% lapply(function(x){
        process_ontology(x)
    })

    memoised = TRUE
    record = new.env()
    record$uris = c()
    imports <- ontologies %>% purrr::map(get_onto_imports,env = record,memoised = memoised) %>%
        unlist(recursive = FALSE)

})


