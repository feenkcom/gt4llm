Class {
	#name : #GtLRequestHistory,
	#superclass : #OrderedCollection,
	#category : 'Gt4LlmCore-Client'
}

{ #category : #'as yet unclassified' }
GtLRequestHistory >> addRequest: aRequest response: aResponse [
	<return: #GtLRequestResponse>
	| aRequestResponse |
	aRequestResponse := GtLRequestResponse new
			request: aRequest;
			response: aResponse.
	self add: aRequestResponse.
	^ aRequestResponse
]

{ #category : #'as yet unclassified' }
GtLRequestHistory >> gtCallsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Calls';
		priority: 5;
		items: [ self ];
		column: 'URL' text: [ :aRequestResponse | aRequestResponse request url ];
		column: 'Request'
			text: [ :aRequestResponse | aRequestResponse request method ]
			width: 100;
		column: 'Response'
			text: [ :aRequestResponse | 
				String
					streamContents: [ :out | aRequestResponse response statusLine writeOn: out ] ]
			width: 150
]

{ #category : #ui }
GtLRequestHistory >> gtClearHistoryActionFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons bin;
		tooltip: 'Clear';
		priority: 80;
		action: [ :aButton :aTab | 
			self removeAll.
			aTab viewContentElement phlow update ]
]
