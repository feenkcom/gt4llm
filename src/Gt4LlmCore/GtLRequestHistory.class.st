Class {
	#name : #GtLRequestHistory,
	#superclass : #OrderedCollection,
	#category : 'Gt4LlmCore-Client'
}

{ #category : #adding }
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
			width: 150;
		actionButtonIcon: BrGlamorousVectorIcons clipboard
			tooltip: 'Copy responses to the clipboard as a store string'
			action: [ :anElement | Clipboard clipboardText: self responseStoreString ]
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

{ #category : #'api - serializing' }
GtLRequestHistory >> responseStoreString [
	| someCopies |
	someCopies := self simplifiedResponses.

	^ someCopies storeString
]

{ #category : #'private - serialization' }
GtLRequestHistory >> simplifiedResponseCopyFrom: aZnResponse [
	| aCopy aHeaders |
	aCopy := aZnResponse copy.
	aHeaders := aCopy headers.

	aHeaders
		removeKey: 'Server' ifAbsent: [  ];
		at: 'Openai-Organization' put: 'stub-organization';
		at: 'Opeanai-Project' put: 'proj_1';
		removeKey: 'Set-Cookie' ifAbsent: [  ];
		removeKey: 'Cf-Ray' ifAbsent: [  ];
		removeKey: 'Alt-Svc' ifAbsent: [  ].

	^ aCopy
]

{ #category : #'api - serializing' }
GtLRequestHistory >> simplifiedResponses [
	^ self
		collect: [ :each | self simplifiedResponseCopyFrom: each response ]
		as: Array
]
