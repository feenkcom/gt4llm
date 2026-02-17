Class {
	#name : #GtLToolForClassActions,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'as yet unclassified' }
GtLToolForClassActions class >> leJsonV4Name [
	^ #gtLToolForClassActions
]

{ #category : #accessing }
GtLToolForClassActions >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForClassActions: self
]

{ #category : #accessing }
GtLToolForClassActions >> description [
	^ 'Gets a class by name and returns a list of its actions.'
]

{ #category : #accessing }
GtLToolForClassActions >> name [
	^ 'getClassActions'
]

{ #category : #accessing }
GtLToolForClassActions >> parametersDescription [
	^ #('className')
]

{ #category : #accessing }
GtLToolForClassActions >> privatePerformToolCall: aToolCall [
	| className targetClass pragmas |
	className := aToolCall anyArgument.
	targetClass := className
			ifNil: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: aToolCall arguments;
					missingArgument: 'className' ]
			ifNotNil: [ className
					asClassIfAbsent: [ ^ GtLMissingDomainObject new objectName: className ] ].

	pragmas := Pragma
			allNamed: #gtAction
			from: targetClass
			toButExcluding: Object.

	^ GtLClassMethodsDomainObject new
		targetClass: targetClass;
		methods: (pragmas collect: [ :each | each method ])
]
