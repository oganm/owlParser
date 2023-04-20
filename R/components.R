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
             default_namespace = ontology_elements$`default-namespace` %>% xml2::xml_contents() %>% as.character(),
             source = onto_xml
        )

    return(ontology)
}


process_class = function(class_xml){
    class_elements <- get_elements(class_xml)


    Class = list(IRI = x %>% xml2::xml_attr('about'),
                 Definition = class_elements$IAO_0000115 %>% xml2::xml_text(),
                 AlternativeIds = class_elements$hasAlternativeId %>% xml2::xml_text(),
                 source = class_xml)
}
