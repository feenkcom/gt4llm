Class {
	#name : #GtLToolForClassViews,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForClassViews >> classNameDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Class name';
		accessor: #className;
		beRequired
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
GtLToolForClassViews >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| className targetClass pragmas |
	className := aToolCall arguments at: 'className'.
	targetClass :=  className
			asClassIfAbsent: [ ^ GtLMissingDomainObject new objectName: className ].

	pragmas := Pragma
			allNamed: #gtView
			from: targetClass
			toButExcluding: Object.

	^ GtLClassMethodsDomainObject new
		targetClass: targetClass;
		methods: (pragmas collect: [ :each | each method ])
]
