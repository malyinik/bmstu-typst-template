#import "template/bmstu.typ": *

#include "title.typ"

#show: config.bmstu_config

#outline()

#include "intro.typ"
#include "analytic_part.typ"
#include "design_part.typ"
#include "tech_part.typ"
#include "experimental_part.typ"
#include "conclusion.typ"
#bibliography("bibliography.yml")
#include "additions.typ"
