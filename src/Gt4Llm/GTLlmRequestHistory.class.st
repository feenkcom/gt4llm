Class {
	#name : #GtLlmRequestHistory,
	#superclass : #OrderedCollection,
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmRequestHistory >> add: aPair [
	super
		add: (GtLlmRequestResponse new
				request: aPair key;
				response: aPair value)
]

{ #category : #'as yet unclassified' }
GtLlmRequestHistory >> gtCallsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Calls';
		priority: 5;
		items: [ self ];
		column: 'URL' text: [ :aRequestResponse | aRequestResponse request url ];
		column: 'Method' text: [ :aRequestResponse | aRequestResponse request method ] width: 100
]

{ #category : #'as yet unclassified' }
GtLlmRequestHistory >> gtClearHistoryActionFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousIcons trash;
		tooltip: 'Clear';
		priority: 80;
		action: [ :aButton :aTab | 
			self removeAll.
			aTab viewContentElement phlow update ]
]
