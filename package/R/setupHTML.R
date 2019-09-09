#' Set up HTML elements
#'
#' Set up Javascript and CSS elements for the custom collapsible class,
#' used in the output of \code{\link{extractCached}} and \code{\link{prettySessionInfo}}. 
#'
#' @details
#' Getting this to work was a real pain in the ass.
#' If someone else knows better Javascript or CSS, they are more than welcome to do this in a more natural way.
#'
#' It is also a bit awkward to have the same JS and CSS chunks present in every HTML document.
#' I guess it's not too bad, though, as it does mean that every page is standalone.
#' This makes things a bit easier in terms of book compilation.
#'
#' @return Prints HTML to set up JS and CSS elements.
#'
#' @author Aaron Lun
#' 
#' @seealso
#' \code{\link{chapterPreamble}}, which calls this function.
#'
#' @export
setupHTML <- function() {
    cat('<script>
document.addEventListener("click", function (event) {
    if (event.target.classList.contains("aaron-collapse")) {
        event.target.classList.toggle("active");
        var content = event.target.nextElementSibling;
        if (content.style.display === "block") {
          content.style.display = "none";
        } else {
          content.style.display = "block";
        }
    }
})
</script>

<style>
.aaron-collapse {
  background-color: #eee;
  color: #444;
  cursor: pointer;
  padding: 18px;
  width: 100%;
  border: none;
  text-align: left;
  outline: none;
  font-size: 15px;
}

.aaron-content {
  padding: 0 18px;
  display: none;
  overflow: hidden;
  background-color: #f1f1f1;
}
</style>')
}
