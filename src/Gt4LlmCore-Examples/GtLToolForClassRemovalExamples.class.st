Class {
	#name : #GtLToolForClassRemovalExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #helpers }
GtLToolForClassRemovalExamples >> ensureClassNamed: aSymbol [
	self removeClassNamedIfPresent: aSymbol.
	^ Object
		subclass: aSymbol
		instanceVariableNames: ''
		classVariableNames: ''
		package: 'Gt4LlmCore-Examples'
]

{ #category : #helpers }
GtLToolForClassRemovalExamples >> removeClassNamedIfPresent: aSymbol [
	Smalltalk globals
		at: aSymbol asSymbol
		ifPresent: [ :cls | cls removeFromSystem ]
]

{ #category : #examples }
GtLToolForClassRemovalExamples >> removeExistingClass [
	<gtExample>
	| tool call result className |
	className := #GtLToolForClassRemovalExamplesTemporary.
	[
		self ensureClassNamed: className.
		tool := GtLToolForClassRemoval new.
		call := GtLFunctionToolCall new.
		call function: {
			'name' -> tool name.
			'arguments' -> {
				'className' -> className
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: result isErrorDomainObject not.
		self assert: (Smalltalk globals includesKey: className) not.
		self assert: (result value at: 'removedClassName') equals: className asString
	] ensure: [ self removeClassNamedIfPresent: className ].
	^ call
]

{ #category : #examples }
GtLToolForClassRemovalExamples >> removeUnknownClass [
	<gtExample>
	| tool call result className |
	className := #GtLToolForClassRemovalExamplesDoesNotExist.
	tool := GtLToolForClassRemoval new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> className
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: result objectName equals: className asString.
	^ call
]
