Class {
	#name : #GtOpenAILepiterSnippetThreadMessage,
	#superclass : #GtOpenAIActionThreadMessage,
	#category : #'Gt4Llm-Tutor'
}

{ #category : #'as yet unclassified' }
GtOpenAILepiterSnippetThreadMessage >> gtAcceptSnippetActionFor: anAction [
	<gtLlmAction>
	self isAssistantRole ifFalse: [ ^ anAction noAction ].
	self snippet isEmptyOrNil ifTrue: [ ^ anAction noAction ].

	^ anAction button
		icon: BrGlamorousVectorIcons accept;
		tooltip: 'Accept snippet';
		action: [ self pipeline instance updateContent: self snippet ]
]

{ #category : #'as yet unclassified' }
GtOpenAILepiterSnippetThreadMessage >> gtContentDiffFor: aView [
	<gtView>
	<gtLlmMessageView>
	self snippet isEmptyOrNil ifTrue: [ ^ aView empty ].
	self pipeline instance content isTextualSnippet ifFalse: [ ^ aView empty ].

	^ aView diff
		title: 'Content diff';
		priority: 4;
		from: [ self pipeline instance content text asString ];
		to: [ self snippetObject text asString ]
]

{ #category : #'as yet unclassified' }
GtOpenAILepiterSnippetThreadMessage >> gtDiffFor: aView [
	<gtView>
	<gtLlmMessageView>
	self snippet isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView diff
		title: 'Snippet diff';
		priority: 5;
		from: [ self pipeline instance contentValue ];
		to: [ self snippet ]
]

{ #category : #'as yet unclassified' }
GtOpenAILepiterSnippetThreadMessage >> gtSnippetFor: aView [
	<gtView>
	<gtLlmMessageView>
	self snippet isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ (self snippetObject asSnippetViewModel gtLiveFor: aView)
		title: 'Snippet';
		priority: 1
]

{ #category : #'as yet unclassified' }
GtOpenAILepiterSnippetThreadMessage >> snippet [
	^ self contentJson at: 'Snippet' ifAbsent: [ '' ]
]

{ #category : #'as yet unclassified' }
GtOpenAILepiterSnippetThreadMessage >> snippetObject [
	^ LeJsonV4 uniqueInstance deserialize: self snippet readStream
]
