class RelationModel

  constructor: (@modelView) ->
    # body...
    @drawLine = new DrawLine(@)
    @relations = []
    @repeatRelations = []
    @lastViewModel
    @click = (viewModel) =>
      if not @lastViewModel?
        @lastViewModel = viewModel
        @lastViewModel.dom.toggleClass 'view-model-select'
        return

      if @lastViewModel == viewModel
        @lastViewModel.dom.toggleClass 'view-model-select'
        @lastViewModel = null
        return

      @lastViewModel.addChild viewModel
      @lastViewModel.dom.toggleClass 'view-model-select'
      @lastViewModel = null
      @update()
      saveSourceData()

    @update = =>
      @relations = []
      relationsKeys = []
      for viewModel in @modelView.views
        if($.isEmptyObject(viewModel.parents))
          @getViewModelRelations viewModel, relationsKeys, @relations
      @repeatRelations = []
      for viewModel in @modelView.views
        relationsKeys = []
        relationsKeys.push viewModel.node.key
        @getRepeatViewModelRelations viewModel.node.key, viewModel, relationsKeys, @repeatRelations

      @drawLine.update()
    @redraw = =>
      @drawLine.draw()

    @getViewModelRelations = (viewModel, relationsKeys, relations) =>
      childs = viewModel.childs
      return if $.isEmptyObject(childs)
      return if relations.length > 1000
      for key, childViewModel of childs
        # body...
        relationsKey = "#{viewModel.node.key}#{childViewModel.node.key}"
        if(relationsKeys.indexOf(relationsKey) < 0)
          relationsKeys.push "#{viewModel.node.key}#{childViewModel.node.key}"
          relations.push [viewModel, childViewModel]
        else
          continue
        @getViewModelRelations childViewModel, relationsKeys, relations
      # console.log "line count #{relations.length}"

    @getRepeatViewModelRelations = (uniqueKey, viewModel, relationsKeys, repeatRelations) =>
      childs = viewModel.childs
      return if $.isEmptyObject(childs)
      for key, childViewModel of childs
        # body...
        relationsKey = "#{childViewModel.node.key}"
        if(relationsKeys.indexOf(relationsKey) > -1)
          repeatRelations.push [viewModel, childViewModel] if uniqueKey == relationsKey
          continue
        relationsKeys.push relationsKey
        @getRepeatViewModelRelations uniqueKey, childViewModel, relationsKeys, repeatRelations
      # console.log "repeat line count #{relations.length}"


    @getRelationData = ()=>
      relationDatas = []
      for relation in @relations
        relationDatas.push [relation[0].node.key,relation[1].node.key]
      relationDatas

    @loadRelationData = (relationDatas)=>
      return if not relationDatas?
      relationMap = {}
      for viewModel in @modelView.views
        relationMap[viewModel.node.key] = viewModel
      for relation in relationDatas
        pViewModel = relationMap[relation[0]]
        cViewModel = relationMap[relation[1]]
        pViewModel.addChild cViewModel
