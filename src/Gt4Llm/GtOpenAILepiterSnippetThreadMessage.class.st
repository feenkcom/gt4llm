Class {
	#name : #GtOpenAILepiterSnippetThreadMessage,
	#superclass : #GtOpenAIActionThreadMessage,
	#category : #'Gt4Llm-Tutor'
}

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
