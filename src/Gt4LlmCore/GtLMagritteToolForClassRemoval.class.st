"
Magritte-based tool for removing a class from the image.
"
Class {
	#name : #GtLMagritteToolForClassRemoval,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #magritte }
GtLMagritteToolForClassRemoval >> classNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class name';
		accessor: #className;
		beRequired
]

{ #category : #accessing }
GtLMagritteToolForClassRemoval >> description [
	^ 'Removes the class with the provided name from the image.

Example JSON arguments:
{
  "className": "MyClass"
}

Example JSON response:
{
  "removedClassName": "MyClass",
  "status": "removed"
}'
]

{ #category : #accessing }
GtLMagritteToolForClassRemoval >> name [
	^ 'removeClass'
]

{ #category : #'tool api' }
GtLMagritteToolForClassRemoval >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| className class |
	
	className := aToolCall arguments at: 'className'.
	className trimBoth isEmpty
		ifTrue: [ ^ GtLMissingDomainObject new 
			objectName: className ].
	class := className asClassIfAbsent: [ ^ GtLMissingDomainObject new 
		objectName: className ].
	
	[ class removeFromSystem ]
		on: Error
		do: [ :ex |
			^ GtLExceptionDomainObject new
				freeze: ex;
				errorReason: 'Error while removing class';
				yourself ].
				
	^ GtLClassRemovalResult new
		removedClassName: className;
		status: 'removed';
		yourself
]
