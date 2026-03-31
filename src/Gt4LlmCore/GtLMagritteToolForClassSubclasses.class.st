"
Magritte-based tool for listing subclasses of a given class.
"
Class {
	#name : #GtLMagritteToolForClassSubclasses,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #magritte }
GtLMagritteToolForClassSubclasses >> classNameDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Class name';
		accessor: #className;
		beRequired
]

{ #category : #accessing }
GtLMagritteToolForClassSubclasses >> description [
	^ 'Retrieve all subclasses of the given class.

Arguments:
- className: string

Return values:
- givenClassName: the input class name string
- subclassNames: array of subclass names as strings

Example JSON arguments:
{
  "className": "Object"
}

Example JSON response:
{
  "givenClassName": "Object",
  "subclassNames": ["Behavior", "UndefinedObject"]
}'
]

{ #category : #testing }
GtLMagritteToolForClassSubclasses >> isUsingDataViews [
	^ true
]

{ #category : #accessing }
GtLMagritteToolForClassSubclasses >> name [
	^ 'classSubclasses'
]

{ #category : #execution }
GtLMagritteToolForClassSubclasses >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments className class subclasses |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	className := arguments	at: 'className'.

	(className trimBoth isEmpty)
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				arguments: arguments;
				missingArgument: 'className' ].

	class := className asSymbol asClassIfAbsent: [ nil ].
	class ifNil: [ ^ GtLMissingDomainObject new objectName: className ].

	subclasses := class subclasses.

	^ (GtLClassSubclasses fromClasses: subclasses)
			givenClassName: className;
			yourself
]
