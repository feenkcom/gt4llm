Class {
	#name : #GtLToolForClassViews,
	#superclass : #GtLAbstractPlainSchemaFunctionTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForClassViews >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForClassViews: self
]

{ #category : #accessing }
GtLToolForClassViews >> description [
	^ 'Gets a class by name and returns a list of its views.'
]

{ #category : #accessing }
GtLToolForClassViews >> name [
	^ 'getClassViews'
]

{ #category : #accessing }
GtLToolForClassViews >> parametersDescription [
	^ #('className')
]

{ #category : #accessing }
GtLToolForClassViews >> privatePerformToolCall: aToolCall [
	| className targetClass pragmas selectors |
	className := aToolCall anyArgument.
	targetClass := className
			ifNil: [ ^ GtLMissingArgumentDomainObject new
					receiverName: self name;
					arguments: aToolCall arguments;
					missingArgument: 'className' ]
			ifNotNil: [ className
					asClassIfAbsent: [ ^ GtLMissingDomainObject new objectName: className ] ].

	pragmas := Pragma
			allNamed: #gtView
			from: targetClass
			toButExcluding: Object.

	^ GtLClassMethodsDomainObject new
		targetClass: targetClass;
		methods: (pragmas collect: [ :each | each method ])
]
