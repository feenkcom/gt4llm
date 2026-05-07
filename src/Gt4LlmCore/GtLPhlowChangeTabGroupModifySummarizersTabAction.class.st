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

{ #category : #'api - actions' }
GtLPhlowChangeTabGroupModifySummarizersTabAction >> collectSummarizedViewsFor: aCollectionOfSummarizers [
	| collectedViews |
	collectedViews := Array
		streamContents: [ :aStream |

		aCollectionOfSummarizers do: [ :aSummarizer |
				aStream nextPutAll: (GtPhlowViewsCollector new
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

{ #category : #private }
GtLPhlowChangeTabGroupModifySummarizersTabAction >> createAddNewViewsActionsIn: aChangeContext [
	| newSummarizerViews |
	newSummarizerViews := self collectSummarizedViewsFor: aChangeContext newRelevantSummarizers.

	addTabActionsByView := newSummarizerViews
			collect: [ :each | 
				each -> (GtPhlowChangeTabGroupAddTabAction new 
					tabGroup: self tabGroup;
					buildContext: each buildContext) ].
	^ addTabActionsByView collect: [ :actionByViewAssoc | 
			| viewDefiningMethod |
			viewDefiningMethod := actionByViewAssoc key definingMethod.
			actionByViewAssoc value prepareOn: (GtPhlowChangeActionAffectedMethodContext
					forAffectedClass: viewDefiningMethod methodClass
					affectedMethod: viewDefiningMethod) ]
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

{ #category : #'api - actions' }
GtLPhlowChangeTabGroupModifySummarizersTabAction >> prepareOn: aChangeContext [
	"Can be called in any process.
	It returns an action that must be executed in a UI process."

	<return: #TGtPhlowChangeUpdateAction>
	| removeActions addActions |
	
	removeActions := self createRemoveExistingViewsActions.
	addActions := self createAddNewViewsActionsIn: aChangeContext.
	
	^ GtPhlowChangeCompositeUpdateAction new
		updateActions: removeActions , addActions
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
