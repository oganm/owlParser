process_ontology = function(onto_xml){
    ontology_elements <- get_elements(onto_xml)
    ns = xml2::xml_ns(onto_xml)
    ontology =
        list(ontologyIRI = onto_xml %>% xml2::xml_attr('rdf:about',ns = ns),
             versionIRI = ontology_elements$`owl:versionIRI` %>% xml2::xml_attr('rdf:resource',ns = ns),
             version = ontology_elements$`owl:versionInfo` %>% xml2::xml_contents() %>% as.character(),
             title = ontology_elements$`dc:title` %>% xml2::xml_contents() %>% as.character(),
             description = ontology_elements$`dc:description` %>% xml2::xml_contents() %>% as.character(),
             roots = ontology_elements$`obo:IAO_0000700` %>% xml2::xml_attr('rdf:resource',ns = ns),
             imports =
                 ontology_elements$`owl:imports` %>% xml2::xml_attr('rdf:resource',ns = ns),
             default_namespace = ontology_elements$`oboInOwl:default-namespace` %>% xml2::xml_contents() %>% as.character(),
             source = as.character(onto_xml),
             xml = onto_xml
        )

    return(ontology)
}


process_class = function(class_xml){
    class_elements <- get_elements(class_xml)

    replacement = c(class_elements$IAO_0100001 %>% xml2::xml_attr('resource'),
                    class_elements$IAO_0100001 %>% xml2::xml_text()) %>% na.omit() %>% {.[.!='']} %>% unique


    Class = list(IRI = class_xml %>% xml2::xml_attr('about'),
                 definition = class_elements$IAO_0000115 %>% xml2::xml_text(),
                 alternativeIds = class_elements$hasAlternativeId %>% xml2::xml_text(),
                 exactMatch = class_elements$exactMatch %>% xml_attr('resource'),
                 xrefs = class_elements$hasDbXref %>% xml_text(),
                 label = class_elements$label %>% xml2::xml_text(),
                 exactSynonyms = class_elements$hasExactSynonym %>% xml2::xml_text(),
                 replacedBy = replacement,
                 deprecated = class_elements$deprecated %>% xml2::xml_text() %>% {ifelse(length(.)!=0 && . =='true',TRUE,FALSE)},
                 source = as.character(class_xml))
}
