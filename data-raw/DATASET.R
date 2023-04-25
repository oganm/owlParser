library(magrittr)


# this seems to fail a lot...

options(timeout=100)



ontology_owls = list(
    chebi = "http://purl.obolibrary.org/obo/chebi.owl",
    doid = "http://purl.obolibrary.org/obo/doid.owl",
    cl = "http://purl.obolibrary.org/obo/cl.owl",
    mp = "http://purl.obolibrary.org/obo/mp.owl",
    hp = "http://purl.obolibrary.org/obo/hp.owl",
    uberon = "http://purl.obolibrary.org/obo/uberon.owl",
    clo = "http://purl.obolibrary.org/obo/clo.owl",
    obi = "http://purl.obolibrary.org/obo/obi.owl",
    go = "http://purl.obolibrary.org/obo/go.owl",
    efo = "https://www.ebi.ac.uk/efo/efo.owl",
    ehdaa= 'http://purl.obolibrary.org/obo/ehdaa2.owl',
    emapa = "http://purl.obolibrary.org/obo/emapa.owl",
    mondo = 'http://purl.obolibrary.org/obo/mondo.owl'
)

ontology_obos = list(
    chebi = 'http://purl.obolibrary.org/obo/chebi.obo',
    doid = 'http://purl.obolibrary.org/obo/doid.obo',
    cl = 'http://purl.obolibrary.org/obo/cl.obo',
    mp = 'http://purl.obolibrary.org/obo/mp.obo',
    hp = 'http://purl.obolibrary.org/obo/hp.obo',
    uberon = 'http://purl.obolibrary.org/obo/uberon/basic.obo',
    efo = 'http://www.ebi.ac.uk/efo/efo.obo',
    ehdaa = 'http://purl.obolibrary.org/obo/ehdaa2.obo',
    emapa = 'http://purl.obolibrary.org/obo/emapa.obo',
    mondo = 'http://purl.obolibrary.org/obo/mondo.obo'
)


dir.create('data-raw/owl',showWarnings = FALSE)
names(ontology_owls) %>% lapply(function(x){
    tryCatch(download.file(ontology_owls[[x]],destfile = file.path('data-raw/owl',x)),
             error = function(e){
                 file.remove(file.path('data-raw/owl',x))
                 cat(paste('owl',x,'\n'),file = 'data-raw/failures',append = TRUE)
             })
})

dir.create('data-raw/obo',showWarnings = FALSE)
names(ontology_obos) %>% lapply(function(x){
    tryCatch(download.file(ontology_obos[[x]],destfile = file.path('data-raw/obo',x)),
             error = function(e){
                 file.remove(file.path('data-raw/obo',x))
                 cat(paste('obo',x,'\n'),file = 'data-raw/failures',append = TRUE)
             })})

