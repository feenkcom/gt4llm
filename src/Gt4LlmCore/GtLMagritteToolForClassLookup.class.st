"
Magritte-based tool for looking up class descriptions.
"
Class {
	#name : #GtLMagritteToolForClassLookup,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #magritte }
GtLMagritteToolForClassLookup >> classNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class name';
		accessor: #className;
		beRequired
]

{ #category : #accessing }
GtLMagritteToolForClassLookup >> description [
	^ 'Get the details of a class as JSON.

Arguments:
- className: string

Return values:
- currentClassName: class name string
- superclassName: superclass name string or nil
- comment: class comment
- packageName: package name
- instanceSlotNames: array of instance slot names
- classSlotNames: array of class slot names
- allInstanceMethodNames: array of selectors
- allClassMethodNames: array of selectors

Example JSON arguments:
{
  "className": "Collection"
}

Example JSON response:
{
  "currentClassName": "Collection",
  "superclassName": "SequenceableCollection",
  "comment": "...",
  "packageName": "Collections-Sequenceable",
  "instanceSlotNames": ["array"],
  "classSlotNames": [],
  "allInstanceMethodNames": ["at:", "size"],
  "allClassMethodNames": ["withAll:"]
}'
]

{ #category : #testing }
GtLMagritteToolForClassLookup >> isUsingDataViews [
	^ true
]

{ #category : #accessing }
GtLMagritteToolForClassLookup >> name [
	^ 'lookupClass'
]

{ #category : #private }
GtLMagritteToolForClassLookup >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments className class |
	arguments := aToolCall arguments.
	
	className := arguments at: 'className'.
	class := className
		asClassIfAbsent: [ ^ GtLMissingDomainObject new objectName: className ].

	^ GtLClassDescription fromClass: class
]
