#import "template/bmstu.typ": *

#include "00_title.typ"

#show: config.bmstu_config

#outline()
#include "01_intro.typ"
#include "02_analytical.typ"
#include "03_design.typ"
#include "04_tech.typ"
#include "05_research.typ"
#include "06_conclusion.typ"
#bibliography("07_references.yml")
#include "08_appendix.typ"
