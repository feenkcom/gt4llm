Class {
	#name : #GtGtGeminiMessageCandidate,
	#superclass : #GtLlmEntity,
	#instVars : [
		'content',
		'finishReason',
		'avgLogprobs',
		'toolCalls'
	],
	#category : #Gt4Gemini
}

{ #category : #'as yet unclassified' }
GtGtGeminiMessageCandidate class >> serializationProperties [
	^ {
		#content -> #content.
		#finishReason -> #finishReason.
		#avgLogprobs -> #avgLogprobs
	}
]

{ #category : #accessing }
GtGtGeminiMessageCandidate >> avgLogprobs [
	^ avgLogprobs
]

{ #category : #accessing }
GtGtGeminiMessageCandidate >> avgLogprobs: anObject [
	avgLogprobs := anObject
]

{ #category : #accessing }
GtGtGeminiMessageCandidate >> content [
	^ content
]

{ #category : #accessing }
GtGtGeminiMessageCandidate >> content: anObject [
	content := GtLlmChatMessage new
			role: 'model';
			content: (''
					join: ((anObject at: 'parts')
							select: [ :aPart | aPart includesKey: 'text' ]
							thenCollect: [ :aPart | aPart at: 'text' ])).

	toolCalls := (anObject at: 'parts')
			select: [ :aPart | aPart includesKey: 'functionCall' ]
			thenCollect: [ :aPart | aPart at: 'functionCall' ]
]

{ #category : #accessing }
GtGtGeminiMessageCandidate >> finishReason [
	^ finishReason
]

{ #category : #accessing }
GtGtGeminiMessageCandidate >> finishReason: anObject [
	finishReason := anObject
]

{ #category : #'as yet unclassified' }
GtGtGeminiMessageCandidate >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView forward
		title: 'Content';
		priority: 5;
		object: [ self content ];
		view: #gtContentFor:
]

{ #category : #'as yet unclassified' }
GtGtGeminiMessageCandidate >> toolCalls [
	^ toolCalls
]
