Class {
	#name : #GtLMagritteToolForClassCommentChange,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #magritte }
GtLMagritteToolForClassCommentChange >> classCommentDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class comment';
		accessor: #classComment;
		kind: String;
		beRequired
]

{ #category : #magritte }
GtLMagritteToolForClassCommentChange >> classNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class name';
		accessor: #className;
		kind: String;
		addCondition: [ :aValue | aValue trimBoth isNotEmpty ]
			labelled: 'Non empty class name';
		beRequired
]

{ #category : #magritte }
GtLMagritteToolForClassCommentChange >> description [
	^ 'Change the class or trait comment. Both, class and trait use the same argument names and response structure.

Example JSON arguments:
{
  "className": "MyClass",
  "classComment": "description of the class"
}

Example JSON response:
{
  "className": "MyClass",
  "status": "changed"
}'
]

{ #category : #magritte }
GtLMagritteToolForClassCommentChange >> name [
	^ 'changeClassOrTraitComment'
]

{ #category : #private }
GtLMagritteToolForClassCommentChange >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments className class classComment originalDescription |
	arguments := aToolCall arguments.

	className := arguments
			at: 'className'
			ifPresent: [ :aString | aString trimBoth ].
	class := className
			asClassIfAbsent: [ ^ GtLMissingDomainObject new objectName: className ].

	classComment := arguments
			at: 'classComment'
			ifPresent: [ :aString | aString trimBoth ].
			
	originalDescription := GtLClassDefinitionDescription
		fromClass: class.

	class comment: classComment.
	
	^ GtLClassCommentChangeResult new
		updatedClass: (GtLClassDefinitionDescription fromClass: class);
		originalClass: originalDescription;
		status: 'changed'
]
