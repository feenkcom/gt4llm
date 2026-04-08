"
Examples for GtLMagritteToolForClassDefinitionChange.
"
Class {
	#name : #GtLMagritteToolForClassDefinitionChangeExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changeClassInstanceVariables [
	<gtExample>
	| className |
	className := #GtLMagritteToolForClassSignatureChangeExamplesWithIvars.
	self removeClassNamedIfPresent: className.
	[
		| tool call result targetObject targetClass |
		targetClass := (Object << className
			slots: { 'first' };
			classSlots: {};
			package: 'Gt4LlmCoreNewPackage') install.
		tool := GtLMagritteToolForClassDefinitionChange new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'classChangeRequest' -> {
				'targetClassName' -> className.
				'superclassName' -> #Object.
				'instanceVariables' -> #('alpha' 'beta').
				'classVariables' -> #().
				'package' -> 'Gt4LlmCoreNewPackage'
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		
		targetObject := result targetObject.
		self assert: (targetObject isKindOf: GtLClassModificationResult).
		self assert: (targetClass instanceVariables collect: #name) equals: #('alpha' 'beta').
		self assert: targetObject instanceSlotNames asArray equals: #('alpha' 'beta').
		call
	] ensure: [ self removeClassNamedIfPresent: className ]
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changeClassVariablesWithPartialArguments [
	<gtExample>
	| className |
	className := #GtLMagritteToolForClassSignatureChangeExamplesPartialCvars.
	self removeClassNamedIfPresent: className.
	[
		| tool call result targetObject targetClass |
		targetClass := Object
			subclass: className
			instanceVariableNames: 'first second'
			classVariableNames: 'OldShared'
			package: 'Gt4LlmCoreNewPackage'.
		tool := GtLMagritteToolForClassDefinitionChange new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'classChangeRequest' -> {
				'targetClassName' -> className.
				'classVariables' -> #('NewShared' 'AnotherShared')
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		
		targetObject := result targetObject.
		self assert: (targetObject isKindOf: GtLClassModificationResult).
		self assert: (targetClass instanceVariables collect: #name) equals: #('first' 'second').
		self assert: (targetClass classVariables collect: #name) asSet equals: #('NewShared' 'AnotherShared') asSet.
		self assert: targetClass superclass equals: Object.
		self assert: targetClass package name equals: 'Gt4LlmCoreNewPackage'.
		self assert: targetObject instanceSlotNames asArray equals: #('first' 'second').
		self assert: targetObject classVariableNames asSet equals: #('NewShared' 'AnotherShared') asSet.
		self assert: targetObject superclassName equals: 'Object'.
		self assert: targetObject packageName equals: 'Gt4LlmCoreNewPackage'.
		call
	] ensure: [ self removeClassNamedIfPresent: className ]
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changeInstanceVariablesWithPartialArguments [
	<gtExample>
	| className |
	className := #GtLMagritteToolForClassSignatureChangeExamplesPartial.
	self removeClassNamedIfPresent: className.
	[
		| tool call result targetObject targetClass |
		targetClass := Object
			subclass: className
			instanceVariableNames: 'first second'
			classVariableNames: 'SharedValue'
			package: 'Gt4LlmCoreNewPackage'.
		tool := GtLMagritteToolForClassDefinitionChange new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'classChangeRequest' -> {
				'targetClassName' -> className.
				'instanceVariables' -> #('alpha' 'beta')
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		
		targetObject := result targetObject.
		self assert: (targetObject isKindOf: GtLClassModificationResult).
		self assert: (targetClass instanceVariables collect: #name) equals: #('alpha' 'beta').
		self assert: (targetClass classVariables collect: #name) equals: #('SharedValue').
		self assert: targetClass superclass equals: Object.
		self assert: targetClass package name equals: 'Gt4LlmCoreNewPackage'.
		self assert: targetObject instanceSlotNames asArray equals: #('alpha' 'beta').
		self assert: targetObject classVariableNames asArray equals: #('SharedValue').
		self assert: targetObject superclassName equals: 'Object'.
		self assert: targetObject packageName equals: 'Gt4LlmCoreNewPackage'.
		call
	] ensure: [ self removeClassNamedIfPresent: className ]
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changePackageWithPartialArguments [
	<gtExample>
	| className |
	className := #GtLMagritteToolForClassSignatureChangeExamplesPartialPkg.
	self removeClassNamedIfPresent: className.
	[
		| tool call result targetObject targetClass |
		targetClass := Object
			subclass: className
			instanceVariableNames: 'first second'
			classVariableNames: 'SharedValue'
			package: 'Gt4LlmCoreNewPackage'.
		tool := GtLMagritteToolForClassDefinitionChange new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'classChangeRequest' -> {
				'targetClassName' -> className.
				'package' -> 'Gt4LlmCoreNewPackage2'
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		
		targetObject := result targetObject.
		self assert: (targetObject isKindOf: GtLClassModificationResult).
		self assert: (targetClass instanceVariables collect: #name) equals: #('first' 'second').
		self assert: (targetClass classVariables collect: #name) equals: #('SharedValue').
		self assert: targetClass superclass equals: Object.
		self assert: targetClass package name equals: 'Gt4LlmCoreNewPackage2'.
		self assert: targetObject instanceSlotNames asArray equals: #('first' 'second').
		self assert: targetObject classVariableNames asArray equals: #('SharedValue').
		self assert: targetObject superclassName equals: 'Object'.
		self assert: targetObject packageName equals: 'Gt4LlmCoreNewPackage2'.
		call
	] ensure: [ self removeClassNamedIfPresent: className ]
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changeSuperclassWithPartialArguments [
	<gtExample>
	| className |
	className := #GtLMagritteToolForClassSignatureChangeExamplesPartialSuper.
	self removeClassNamedIfPresent: className.
	[
		| tool call result targetObject targetClass |
		targetClass := Object
			subclass: className
			instanceVariableNames: 'first second'
			classVariableNames: 'SharedValue'
			package: 'Gt4LlmCoreNewPackage'.
		tool := GtLMagritteToolForClassDefinitionChange new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'classChangeRequest' -> {
				'targetClassName' -> className.
				'superclassName' -> 'Exception'
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		
		targetObject := result targetObject.
		self assert: (targetObject isKindOf: GtLClassModificationResult).
		self assert: (targetClass instanceVariables collect: #name) equals: #('first' 'second').
		self assert: (targetClass classVariables collect: #name) equals: #('SharedValue').
		self assert: targetClass superclass equals: Exception.
		self assert: targetClass package name equals: 'Gt4LlmCoreNewPackage'.
		self assert: targetObject instanceSlotNames asArray equals: #('first' 'second').
		self assert: targetObject classVariableNames asArray equals: #('SharedValue').
		self assert: targetObject superclassName equals: 'Exception'.
		self assert: targetObject packageName equals: 'Gt4LlmCoreNewPackage'.
		call
	] ensure: [ self removeClassNamedIfPresent: className ]
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changeUnknownClass [
	<gtExample>
	| tool call result targetObject className |
	className := #GtLMagritteToolForClassSignatureChangeExamplesMissing.
	self removeClassNamedIfPresent: className.
	tool := GtLMagritteToolForClassDefinitionChange new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'classChangeRequest' -> {
			'targetClassName' -> className.
			'superclassName' -> #Object.
			'instanceVariables' -> #().
			'classVariables' -> #().
			'package' -> 'Gt4LlmCoreNewPackage'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertMissingObject: targetObject
		withObjectName: className asString
		errorMessage: className asString, ' is not found'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changeWithMissingClassChangeRequest [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassDefinitionChange new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('classChangeRequest')
		path: #(nil)
		errorMessage: 'required properties missing [classChangeRequest]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changeWithMissingTargetClassName [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassDefinitionChange new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'classChangeRequest' -> {
			'superclassName' -> 'Object'.
			'package' -> 'SomePackage'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertMissingRequiredProperties: targetObject
		withPropertyNames: #('targetClassName')
		path: #('classChangeRequest')
		errorMessage: '@[classChangeRequest] required properties missing [targetClassName]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changeWithNilClassChangeRequest [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassDefinitionChange new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'classChangeRequest' -> nil
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #('classChangeRequest')
		errorMessage: '@[classChangeRequest] object expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changeWithNilTargetClassName [
	<gtExample>
	| tool call result targetObject |
	tool := GtLMagritteToolForClassDefinitionChange new.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'classChangeRequest' -> {
			'targetClassName' -> nil.
			'superclassName' -> 'Object'.
			'package' -> 'SomePackage'
		} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	
	targetObject := result targetObject.
	self
		assertJSONSchemaValidationError: targetObject
		withPath: #(#classChangeRequest #targetClassName)
		errorMessage: '@[classChangeRequest/targetClassName] string expected'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changeWithUnknownSuperclass [
	<gtExample>
	| className |
	className := #GtLMagritteToolForClassSignatureChangeExamplesUnknownSuper.
	self removeClassNamedIfPresent: className.
	[
		| tool call result targetObject targetClass |
		targetClass := Object
			subclass: className
			instanceVariableNames: ''
			classVariableNames: ''
			package: 'Gt4LlmCoreNewPackage'.
		tool := GtLMagritteToolForClassDefinitionChange new.
		call := GtLFunctionToolCall new.
		call rawArguments: {
			'classChangeRequest' -> {
				'targetClassName' -> className.
				'superclassName' -> 'NonExistentSuperclass42'
			} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: (result isKindOf: GTLDataViewWrapperModel).
		
		targetObject := result targetObject.
		self
			assertMissingObject: targetObject
			withObjectName: 'NonExistentSuperclass42'
			errorMessage: 'NonExistentSuperclass42 is not found'.
		call
	] ensure: [ self removeClassNamedIfPresent: className ]
]

{ #category : #private }
GtLMagritteToolForClassDefinitionChangeExamples >> removeClassNamedIfPresent: aSymbol [
	Smalltalk globals
		at: aSymbol asSymbol
		ifPresent: [ :cls | cls removeFromSystem ]
]
