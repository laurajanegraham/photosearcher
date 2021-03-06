#' Find correct location informatio for a given place
#'
#' @param place Text string describing the place for the query
#'
#' @return A dataframe of places including woe_id to be used in location_tags
#' @export
#' @name findPlaces
#'
#' @examples
#' \dontrun{
#' find_place(place = "New York")
#' 
#' find_place(place = "England")
#' }
find_place <- function(place = NULL) {
  if (is.null(place) == TRUE) {
    stop("provide a place")
  }

  api_key <- as.character(get_key())

  place <- gsub(" ", "+", trimws(place))

  place_url <- paste("https://api.flickr.com/services/rest/?method=flickr.places.find&api_key=", api_key, "&query=", place, sep = "")

  place_xml <- search_url(base_url = place_url)

  if (!is.null(place_xml)) {
    place_atts <- xml2::xml_find_all(place_xml, "//place", ns = xml2::xml_ns(place_xml))
    place_data <- dplyr::bind_rows(lapply(xml2::xml_attrs(place_atts), function(x) data.frame(as.list(x), stringsAsFactors = FALSE)))
  }

  return(place_data)
}
