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
