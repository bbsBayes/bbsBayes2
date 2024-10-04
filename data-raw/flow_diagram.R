library(DiagrammeR)
gri <- grViz("digraph functions {

  # a 'graph' statement
  graph [overlap = true, fontsize = 10 compound = true, ranksep = 0.5]

  # several 'node' statements
  node [shape = rectangle, fontname = 'Courier New',
        fixedsize = false, style=filled, fillcolor=white]

  fetch [label = 'fetch_bbs_data()', fillcolor=lightblue]
  remove [label = 'remove_cache()', fillcolor=orange]
  loadbbs [label = 'load_bbs_data()', fillcolor=lightblue]

  search [label = 'search_species()', fillcolor=orange]
  strat [label = 'stratify()', fillcolor=lightpink]
  prepdata [label = 'prepare_data()', fillcolor=lightpink]
  prepspatial [label = 'prepare_spatial()', fillcolor=lightpink]
  prepmodel [label = 'prepare_model()', fillcolor=darkolivegreen3]
  loadmap [label = 'load_map()', fillcolor=orange]
  assign_ps [label = 'assign_prov_state()', fillcolor=orange]

  runmodel [label = 'run_model()', fillcolor=darkolivegreen3]
  modelfile [label = 'copy_model_file()', fillcolor=darkolivegreen3]

  conv[label = 'save_model_run()\nget_convergence()\nget_model_vars()\nget_summary()', fillcolor=darkolivegreen3]

  genind [label = 'generate_indices()', fillcolor=thistle]
  gentre [label = 'generate_trends()', fillcolor=thistle]
  geo [label = 'plot_geofacet()', fillcolor=thistle]
  plotind [label = 'plot_indices()', fillcolor=thistle]
  genmap [label = 'plot_map()', fillcolor=thistle]


  # several 'edge' statements
  edge []
  fetch->remove [style=dashed]
  fetch->loadbbs [style=dashed]
  fetch->strat [style=dashed]

  runmodel->remove [style=dashed]

  modelfile->prepmodel [style=dashed]

  search->strat [style=dashed]
  strat->prepdata
  prepdata->prepspatial
  prepdata->prepmodel [color=grey50]
  prepspatial->prepmodel [color=grey50]
  prepmodel->runmodel


  runmodel->conv
  runmodel->genind
  genind->gentre

  loadmap->assign_ps  [style=dashed]
  loadmap->genind [style=dashed]
  loadmap->prepspatial [style=dashed]
  loadmap->strat [style=dashed]

  genind->plotind
  genind->geo
  gentre->geo [color=grey50]
  gentre->genmap

  # Invisible edges for arranging
  prepspatial->conv [style=invis]
}")


export_graph(file_name = "flow_diagram.png",
             graph = gri,
             file_type = "png",
    width = 1200,height = 1400)
print(gri)
dev.off()


