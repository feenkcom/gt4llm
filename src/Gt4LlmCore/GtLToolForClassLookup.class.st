Class {
	#name : #GtLToolForClassLookup,
	#superclass : #GtLAbstractFunctionTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #'as yet unclassified' }
GtLToolForClassLookup class >> leJsonV4Name [
	^ #gtLToolForClassLookup
]

{ #category : #accessing }
GtLToolForClassLookup >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForClassLookup: self
]

{ #category : #accessing }
GtLToolForClassLookup >> description [
	^ 'Get the details of a class as JSON.'
]

{ #category : #accessing }
GtLToolForClassLookup >> name [
	^ 'lookupClass'
]

{ #category : #accessing }
GtLToolForClassLookup >> parameterClassName [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class name';
		accessor: #className
]

{ #category : #accessing }
GtLToolForClassLookup >> parameters [
	^ #('className')
]

{ #category : #accessing }
GtLToolForClassLookup >> privatePerformToolCall: aToolCall [
	| arguments className class |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	className := arguments
			at: 'className'
			ifAbsent: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: arguments;
					missingArgument: 'className' ].
	class := className
			asClassIfAbsent: [ ^ GtLMissingDomainObject new objectName: className ].

	^ GtLClassDomainObject new foundClass: class
]
