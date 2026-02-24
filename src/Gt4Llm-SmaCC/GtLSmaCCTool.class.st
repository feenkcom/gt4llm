Class {
	#name : #GtLSmaCCTool,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#instVars : [
		'model'
	],
	#category : 'Gt4Llm-SmaCC-Tools'
}

{ #category : #'as yet unclassified' }
GtLSmaCCTool >> grammarIn: anObject do: aBlock onError: errorBlock [
	| grammar |
	anObject parserClass isEmptyOrNil
		ifTrue: [ ^ errorBlock
				value: (GtLMissingArgumentDomainObject new
						arguments: nil;
						missingArgument: 'parserClass') ].
	grammar := model grammarFor: anObject parserClass.
	grammar
		ifNil: [ ^ errorBlock
				value: (GtLProblemDomainObject new
						description: anObject parserClass , ' is not a SmaCC parser class.') ].
	^ aBlock value: grammar
]

{ #category : #accessing }
GtLSmaCCTool >> model [
	^ model
]

{ #category : #accessing }
GtLSmaCCTool >> model: anObject [
	model := anObject
]
