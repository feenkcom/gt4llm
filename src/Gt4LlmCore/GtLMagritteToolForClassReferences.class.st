"
Magritte-based tool for retrieving class references.
"
Class {
	#name : #GtLMagritteToolForClassReferences,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLMagritteToolForClassReferences >> classNameDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Class name';
		accessor: #className;
		beRequired
]

{ #category : #accessing }
GtLMagritteToolForClassReferences >> description [
	^ 'Search the image for the references to the given class.

Arguments:
- className: string

Return values:
- givenClassName: the input class name string
- references: array of method references
- mayHaveMore: boolean indicating if there are more matches than returned

Example JSON arguments:
{
  "className": "Collection"
}

Example JSON response:
{
  "givenClassName": "Collection",
  "references": [
    {
      "methodClassName": "Collection",
      "methodName": "withAll:",
      "classSide": true
    }
  ],
  "mayHaveMore": false
}'
]

{ #category : #accessing }
GtLMagritteToolForClassReferences >> name [
	^ 'classReferences'
]

{ #category : #private }
GtLMagritteToolForClassReferences >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments className class references limitedReferences |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	className := arguments
		at: 'className'
		ifAbsent: [ ^ GtLMissingArgumentDomainObject new
				arguments: arguments;
				missingArgument: 'className' ].

	(className isNil or: [ className trimBoth isEmpty ])
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				arguments: arguments;
				missingArgument: 'className' ].

	class := className asSymbol asClassIfAbsent: [ nil ].
	class ifNil: [ ^ GtLMissingDomainObject new objectName: className ].

	references := (class gtReferences result toArray
		await: GtLSettings futureExecutionConfiguration) wait.
	limitedReferences := (references first: (200 min: references size))
		collect: [ :each | GtLMethodReference fromCompiledMethod: each ].

	^ GtLClassReferences new
		givenClassName: className;
		references: limitedReferences;
		mayHaveMore: references size > 200;
		yourself
]
