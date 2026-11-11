Class {
	#name : #GtLPhlowChangeTabGroupModifySummarizersTabAction,
	#superclass : #GtPhlowChangeAction,
	#instVars : [
		'tabGroup',
		'removeTabActionsByTab',
		'addTabActionsByView'
	],
	#category : #'Gt4LlmCore-UI'
}

{ #category : #private }
GtLPhlowChangeTabGroupModifySummarizersTabAction >> collectSummarizedViewsFor: aCollectionOfSummarizers [
	| collectedViews |
	collectedViews := Array
			streamContents: [ :aStream | 
				aCollectionOfSummarizers
					do: [ :aSummarizer | 
						aStream
							nextPutAll: (GtPhlowViewsCollector new
									fromObject: aSummarizer;
									pragmaNames: GtLSettings messageViewPragmaNames;
									collect) ] ].

	GtPhlowUtility sortByPriority: collectedViews.

	^ collectedViews
]

{ #category : #accessing }
GtLPhlowChangeTabGroupModifySummarizersTabAction >> compositeView [
	^ self tabGroup phlow entity
]

{ #category : #accessing }
GtLPhlowChangeTabGroupModifySummarizersTabAction >> contentsBuilder [
	^ addTabActionsByView contentsBuilder
]

{ #category : #accessing }
GtLPhlowChangeTabGroupModifySummarizersTabAction >> contentsBuilder: anObject [
	addTabActionsByView contentsBuilder: anObject
]

{ #category : #updating }
GtLPhlowChangeTabGroupModifySummarizersTabAction >> createAddNewViewsActionsIn: aChangeContext using: contextsByMethod [
 | newSummarizerViews |
 newSummarizerViews := self collectSummarizedViewsFor: aChangeContext newRelevantSummarizers.
 addTabActionsByView := newSummarizerViews collect: [ :view |
  view -> (GtPhlowChangeTabGroupAddTabAction new
   tabGroup: self tabGroup;
   buildContext: view buildContext) ].
 ^ addTabActionsByView collect: [ :association |
  | method context |
  method := association key definingMethod.
  "Reuse the context in which removal records whether this view was selected."
  context := contextsByMethod at: method ifAbsentPut: [
   GtPhlowChangeActionAffectedMethodContext
    forAffectedClass: method methodClass affectedMethod: method ].
  association value prepareOn: context ]
]

{ #category : #private }
GtLPhlowChangeTabGroupModifySummarizersTabAction >> createRemoveExistingViewsActions [
	| existingTabs |
	existingTabs := self tabGroup viewModel tabs
			select: [ :aTabModel | 
				| isDetected |
				isDetected := false.
				aTabModel
					widgetDo: [ :aWidget | 
						isDetected := aWidget phlow definingMethod methodClass
								inheritsFrom: GtLToolCallsSummarizer ].
				isDetected ].
	removeTabActionsByTab := existingTabs
			collect: [ :aTab | aTab -> (GtPhlowChangeTabGroupRemoveTabAction new tabGroup: self tabGroup) ].
	^ removeTabActionsByTab
		collect: [ :assoc | 
			| viewDefiningMethod |
			viewDefiningMethod := assoc key widget phlow definingMethod.
			assoc value
				prepareOn: (GtPhlowChangeActionAffectedMethodContext
						forAffectedClass: viewDefiningMethod methodClass
						affectedMethod: viewDefiningMethod) ].
]

{ #category : #initialization }
GtLPhlowChangeTabGroupModifySummarizersTabAction >> initialize [
	super initialize.

	addTabActionsByView := OrderedCollection new.
	removeTabActionsByTab := OrderedCollection new.
]

{ #category : #updating }
GtLPhlowChangeTabGroupModifySummarizersTabAction >> prepareOn: aChangeContext [
 "Can be called in any process. The returned action executes in the UI process."
 <return: #TGtPhlowChangeUpdateAction>
 | removeActions addActions contextsByMethod |
 removeActions := self createRemoveExistingViewsActions.
 contextsByMethod := Dictionary new.
 removeActions do: [ :action |
  contextsByMethod at: action changeContext affectedMethodDefinition put: action changeContext ].
 addActions := self createAddNewViewsActionsIn: aChangeContext using: contextsByMethod.
 ^ GtPhlowChangeCompositeUpdateAction new
  updateActions: removeActions, addActions
]

{ #category : #accessing }
GtLPhlowChangeTabGroupModifySummarizersTabAction >> tabGroup [
	^ tabGroup
]

{ #category : #accessing }
GtLPhlowChangeTabGroupModifySummarizersTabAction >> tabGroup: anObject [
	tabGroup := anObject.
]

{ #category : #'api - actions' }
GtLPhlowChangeTabGroupModifySummarizersTabAction >> update: aResult on: aChangeContext [
	"Must be called in a UI process.
	This method is not called since the #prepareOn: returns 
	an action that calls dirrectly remove and add actions."
	
]
