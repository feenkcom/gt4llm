Class {
	#name : #GtLToolForClassSubclasses,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForClassSubclasses class >> leJsonV4Name [
	^ #gtLToolForClassSubclasses
]

{ #category : #accessing }
GtLToolForClassSubclasses >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForClassSubclasses: self
]

{ #category : #accessing }
GtLToolForClassSubclasses >> description [
	^ 'Retrieve all subclasses of the given class'
]

{ #category : #accessing }
GtLToolForClassSubclasses >> name [
	^ 'classSubclasses'
]

{ #category : #accessing }
GtLToolForClassSubclasses >> parametersDescription [
	^ #('className')
]

{ #category : #accessing }
GtLToolForClassSubclasses >> privatePerformToolCall: aToolCall [
	| className class subclasses |
	className := aToolCall anyArgument.
	(className isNil or: [ className trimBoth isEmpty ])
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				receiverName: self name;
				arguments: aToolCall arguments;
				missingArgument: 'className' ].

	class := className asSymbol asClassIfAbsent: [ nil ].
	class ifNil: [ ^ GtLMissingDomainObject new objectName: className ].

	subclasses := class subclasses.

	^ GtLClassSubclassesDomainObject new
		foundClass: class;
		subclasses: subclasses
]
