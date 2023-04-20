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
             source = as.character(onto_xml)
        )

    return(ontology)
}


process_class = function(class_xml){
    class_elements <- get_elements(class_xml)

    replacement = c(class_elements$IAO_0100001 %>% xml2::xml_attr('resource'),
                    class_elements$IAO_0100001 %>% xml2::xml_text()) %>% na.omit() %>% {.[.!='']} %>% unique


    Class = list(IRI = class_xml %>% xml2::xml_attr('about'),
                 Definition = class_elements$IAO_0000115 %>% xml2::xml_text(),
                 AlternativeIds = class_elements$hasAlternativeId %>% xml2::xml_text(),
                 ReplacedBy = replacement,
                 deprecated = class_elements$deprecated %>% xml2::xml_text() %>% {ifelse(length(.)!=0 && . =='true',TRUE,FALSE)},
                 source = as.character(class_xml))
}
