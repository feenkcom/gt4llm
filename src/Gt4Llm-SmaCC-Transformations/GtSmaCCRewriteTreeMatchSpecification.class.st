Class {
	#name : #GtSmaCCRewriteTreeMatchSpecification,
	#superclass : #GtSmaCCRewriteMatchSpecification,
	#instVars : [
		'startingState',
		'pattern'
	],
	#category : #'Gt4Llm-SmaCC-Transformations-Domain Objects'
}

{ #category : #'json schema' }
GtSmaCCRewriteTreeMatchSpecification class >> jsonSchemaLabel [
	^ 'SmaCCTreeMatch'
]

{ #category : #converting }
GtSmaCCRewriteTreeMatchSpecification >> asSmaCCMatch [
	^ SmaCCRewriteTreeMatch new
		startingState: self startingState;
		source: self pattern;
		yourself
]

{ #category : #accessing }
GtSmaCCRewriteTreeMatchSpecification >> pattern [
	^ pattern
]

{ #category : #accessing }
GtSmaCCRewriteTreeMatchSpecification >> pattern: anObject [
	pattern := anObject
]

{ #category : #accessing }
GtSmaCCRewriteTreeMatchSpecification >> patternDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #pattern;
		comment: 'The source of pattern ast to match.'
]

{ #category : #accessing }
GtSmaCCRewriteTreeMatchSpecification >> startingState [
	^ startingState
]

{ #category : #accessing }
GtSmaCCRewriteTreeMatchSpecification >> startingState: anObject [
	startingState := anObject
]

{ #category : #accessing }
GtSmaCCRewriteTreeMatchSpecification >> startingStateDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #startingState;
		comment: 'The starting state for the parser to parse the source. The possible starting states can be obtained from the `%start` directive in the SmaCC parser.'
]
