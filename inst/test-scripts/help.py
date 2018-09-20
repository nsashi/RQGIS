import qgis.utils
qgis.utils.showPluginHelp(filename = "C:\\OSGeo4W64\\apps\\grass\\grass-6.4.3\\docs\\html\\g.mlist")

from processing.core.Processing import Processing
from processing.core.Processing import Processing
from processing.gui.Help2Html import *    
from processing.tools.help import createAlgorithmHelp
algName = "saga:convertlinestopoints"
alg = Processing.getAlgorithm(algName)
folder = "D:/tmp"
# from processing.tools.help import *
# copied from baseHelpForAlgorithm in processing\tools\help.py
baseDir = os.path.join(folder, alg.provider.getName().lower())
groupName = alg.group.lower()
groupName = groupName.replace('[', '').replace(']', '').replace(' - ', '_')
groupName = groupName.replace(' ', '_')
cmdLineName = alg.commandLineName()
algName = cmdLineName[cmdLineName.find(':') + 1:].lower()
validChars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_'
safeGroupName = ''.join(c for c in groupName if c in validChars)
safeAlgName = ''.join(c for c in algName if c in validChars)
dirName = os.path.join(baseDir, safeGroupName)
filePath = os.path.join(dirName, safeAlgName + '.rst')

algName = "qgis:addfieldtoattributestable"
algName = "grass:r.kappa"
folder = "D:/tmp"
createAlgorithmHelp(algName, folder)
getHtmlFromRstFile("D:/tmp/qgis/vector_table_tools/addfieldtoattributestable.rst")
getHtmlFromRstFile("D:/tmp/grass/raster_r/rkappa.rst")

# get qgis 2.8
# see processing/algs/help/__init__.py
version = ".".join(QGis.QGIS_VERSION.split(".")[0:2])
overrideLocale = QSettings().value('locale/overrideFlag', False, bool)
if not overrideLocale:
  locale = QLocale.system().name()[:2]
else:
  locale = QSettings().value('locale/userLocale', '')
locale = locale.split("_")[0]
"https://docs.qgis.org/%s/%s/docs/user_manual/processing_algs/" % (version, locale)

https://docs.qgis.org/2.8/en/docs/user_manual/processing_algs/qgis/vector_analysis_tools/meancoordinates.html
http://docs.qgis.org/2.8/en/docs/user_manual/processing_algs/qgis/vector_analysis_tools/countpointsinpolygon.html
alg <- "grass:r.kappa"
alg <- "grass7:r.kappa"

get_html_help <- function(alg, qgis_env) {
  # create a temporary folder
  tmp_dir <- tempdir()
  cmds <- build_cmds(qgis_env)
  py_cmd <- 
    c(cmds$py_cmd,
      "from processing.core.Processing import Processing",
      "from processing.gui.Help2Html import *",
      "from processing.tools.help import createAlgorithmHelp",
      # from processing.tools.help import *
      
      paste0("alg = Processing.getAlgorithm(", alg, ")"), 
      # copied from baseHelpForAlgorithm in processing\tools\help.py
      "baseDir = os.path.join(folder, alg.provider.getName().lower())",
      "groupName = alg.group.lower()",
      "groupName = groupName.replace('[', '').replace(']', '').replace(' - ', '_')",
      "groupName = groupName.replace(' ', '_')",
      "cmdLineName = alg.commandLineName()",
      "algName = cmdLineName[cmdLineName.find(':') + 1:].lower()",
      "validChars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_'",
      "safeGroupName = ''.join(c for c in groupName if c in validChars)",
      "safeAlgName = ''.join(c for c in algName if c in validChars)",
      "dirName = os.path.join(baseDir, safeGroupName)", 
      "filePath = os.path.join(dirName, safeAlgName + '.rst')",
      
      # now, for the help file
      paste0("createAlgorithmHelp(cmdLineName, '", tmp_dir, "')"),
      "getHtmlFromRstFile(filePath)"
      )

if (grepl("grass", alg)) {
  grass_name <- gsub(".*:", "", alg)
  url <- ifelse(grepl(7, alg),
  paste0("http://grass.osgeo.org/grass70/manuals/", grass_name, ".html"),
  paste0("http://grass.osgeo.org/grass64/manuals/", grass_name, ".html"))
  browseURL(url)
}

