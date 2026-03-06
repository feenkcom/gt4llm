"
Examples for GtLMagritteToolForPackageClasses.
"
Class {
	#name : #GtLMagritteToolForPackageClassesExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForPackageClassesExamples >> packageClassesForBlocReturns200 [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForPackageClasses new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'packageName' -> 'Bloc' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLClassesSearchResult).
	self assert: model foundClassNames size equals: 200.
	self assert: model mayHaveMore.
	^ call
]

{ #category : #examples }
GtLMagritteToolForPackageClassesExamples >> packageClassesForExistingPackage [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForPackageClasses new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'packageName' -> 'GToolkit-Boxer' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLClassesSearchResult).
	self assert: (model foundClassNames includes: 'GtArrayBox').
	self assert: model mayHaveMore not.
	^ call
]

{ #category : #examples }
GtLMagritteToolForPackageClassesExamples >> packageClassesForPackageWithNoClasses [
	<gtExample>
	| tool call result model organizer packageName package existed |
	tool := GtLMagritteToolForPackageClasses new.
	organizer := PackageOrganizer packageOrganizer.
	packageName := 'EmptyPackageWithNoClasses'.
	organizer ensurePackage: packageName asSymbol.
	[
		call := GtLFunctionToolCall new.
		call rawArguments: { 'packageName' -> packageName } asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GtLMagritteBasedModel).
		model := result model.
		self assert: (model isKindOf: GtLClassesSearchResult).
		self assert: model foundClassNames equals: #().
		self assert: model mayHaveMore not
	] ensure: [
		organizer unregisterPackage: package 
	].
	^ call
]

{ #category : #examples }
GtLMagritteToolForPackageClassesExamples >> packageClassesForUnknownPackage [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForPackageClasses new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'packageName' -> 'NonExistingPackageName42' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLMissingDomainObject).
	self assert: model objectName equals: 'NonExistingPackageName42'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForPackageClassesExamples >> packageClassesWithEmptyPackageName [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForPackageClasses new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'packageName' -> '' } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: call arguments size equals: 1.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: (model isKindOf: GtLMissingArgumentDomainObject).
	self assert: model missingArgument equals: 'packageName'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForPackageClassesExamples >> packageClassesWithNilPackageName [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForPackageClasses new.
	call := GtLFunctionToolCall new.
	call rawArguments: { 'packageName' -> nil } asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: (model isKindOf: GtLJSONSchemaValidationErrorDomainObject).
	self assert: model path asArray equals: #('packageName').
	self assert: model errorMessage equals: '@[packageName] string expected'.
	^ call
]
