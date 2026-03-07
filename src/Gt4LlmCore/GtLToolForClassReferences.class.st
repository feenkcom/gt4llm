Class {
	#name : #GtLToolForClassReferences,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #testing }
GtLToolForClassReferences class >> isDeprecated [
	^ true
]

{ #category : #accessing }
GtLToolForClassReferences >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForClassReferences: self
]

{ #category : #accessing }
GtLToolForClassReferences >> description [
	^ 'Search the image for the references to the given class'
]

{ #category : #accessing }
GtLToolForClassReferences >> name [
	^ 'classReferences'
]

{ #category : #accessing }
GtLToolForClassReferences >> parametersDescription [
	^ #('className')
]

{ #category : #accessing }
GtLToolForClassReferences >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| className class references promise |
	className := aToolCall anyArgument.
	(className isNil or: [ className trimBoth isEmpty ])
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				arguments: aToolCall arguments;
				missingArgument: 'className' ].

	class := className asSymbol asClassIfAbsent: [ nil ].
	class ifNil: [ ^ GtLMissingDomainObject new objectName: className ].

	promise := class gtReferences result toArray
			await: GtLSettings futureExecutionConfiguration.
	references := promise wait.

	^ GtLClassReferencesDomainObject new
		foundClass: class;
		references: references
]
