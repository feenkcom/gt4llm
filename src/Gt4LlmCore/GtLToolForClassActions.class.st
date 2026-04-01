Class {
	#name : #GtLToolForClassActions,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForClassActions >> classNameDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Class name';
		accessor: #className;
		beRequired
]

{ #category : #accessing }
GtLToolForClassActions >> description [
	^ 'Gets a class by name and returns a list of its actions.'
]

{ #category : #accessing }
GtLToolForClassActions >> isUsingDataViews [
	^ true
]

{ #category : #accessing }
GtLToolForClassActions >> name [
	^ 'getClassActions'
]

{ #category : #accessing }
GtLToolForClassActions >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| className targetClass pragmas |
	className := aToolCall arguments at: 'className'.
	targetClass :=  className
				asClassIfAbsent: [ ^ GtLMissingDomainObject new objectName: className ].

	pragmas := Pragma
			allNamed: #gtAction
			from: targetClass
			toButExcluding: Object.

	^ GtLClassMethodsDomainObject new
		targetClass: targetClass;
		methods: (pragmas collect: [ :each | each method ])
]
