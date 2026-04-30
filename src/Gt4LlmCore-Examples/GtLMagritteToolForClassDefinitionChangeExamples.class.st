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
	| className call |
	
	className := #GtLMagritteToolForClassSignatureChangeExamplesWithIvars.
	self removeClassNamedIfPresent: className.
	[
		| targetClass targetObject |
		targetClass := (Object << className
			slots: { 'first' };
			classSlots: {};
			package: 'Gt4LlmCoreNewPackage') install.
		call := self
			executeTool: GtLMagritteToolForClassDefinitionChange new
			withArguments: {
				'classChangeRequest' -> {
					'targetClassName' -> className.
					'superclassName' -> #Object.
					'instanceVariables' -> #('alpha' 'beta').
					'classVariables' -> #().
					'package' -> 'Gt4LlmCoreNewPackage'
				} asDictionary
			} asDictionary.
		targetObject := call result targetObject.
		
		self assert: (targetObject isKindOf: GtLClassModificationResult).
		self assert: (targetClass instanceVariables collect: #name) equals: #('alpha' 'beta').
		self assert: targetObject instanceSlotNames asArray equals: #('alpha' 'beta')
	] ensure: [ self removeClassNamedIfPresent: className ].
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changeClassVariablesWithPartialArguments [
	<gtExample>
	| className call |
	
	className := #GtLMagritteToolForClassSignatureChangeExamplesPartialCvars.
	self removeClassNamedIfPresent: className.
	[
		| targetClass targetObject |
		targetClass := ((Object
			<< className)
			slots: { #first . #second };
			sharedVariables: { #OldShared };
			package: 'Gt4LlmCoreNewPackage') install.
		call := self
			executeTool: GtLMagritteToolForClassDefinitionChange new
			withArguments: {
				'classChangeRequest' -> {
					'targetClassName' -> className.
					'classVariables' -> #('NewShared' 'AnotherShared')
				} asDictionary
			} asDictionary.
		targetObject := call result targetObject.
		
		self assert: (targetObject isKindOf: GtLClassModificationResult).
		self assert: (targetClass instanceVariables collect: #name) equals: #('first' 'second').
		self assert: (targetClass classVariables collect: #name) asSet equals: #('NewShared' 'AnotherShared') asSet.
		self assert: targetClass superclass equals: Object.
		self assert: targetClass package name equals: 'Gt4LlmCoreNewPackage'.
		self assert: targetObject instanceSlotNames asArray equals: #('first' 'second').
		self assert: targetObject classVariableNames asSet equals: #('NewShared' 'AnotherShared') asSet.
		self assert: targetObject superclassName equals: 'Object'.
		self assert: targetObject packageName equals: 'Gt4LlmCoreNewPackage'
	] ensure: [ self removeClassNamedIfPresent: className ].
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changeInstanceVariablesWithPartialArguments [
	<gtExample>
	| className call |
	
	className := #GtLMagritteToolForClassSignatureChangeExamplesPartial.
	self removeClassNamedIfPresent: className.
	[
		| targetClass targetObject |
		targetClass := ((Object
			<< className)
			slots: { #first . #second };
			sharedVariables: { #SharedValue };
			package: 'Gt4LlmCoreNewPackage') install.
		call := self
			executeTool: GtLMagritteToolForClassDefinitionChange new
			withArguments: {
				'classChangeRequest' -> {
					'targetClassName' -> className.
					'instanceVariables' -> #('alpha' 'beta')
				} asDictionary
			} asDictionary.
		targetObject := call result targetObject.
		
		self assert: (targetObject isKindOf: GtLClassModificationResult).
		self assert: (targetClass instanceVariables collect: #name) equals: #('alpha' 'beta').
		self assert: (targetClass classVariables collect: #name) equals: #('SharedValue').
		self assert: targetClass superclass equals: Object.
		self assert: targetClass package name equals: 'Gt4LlmCoreNewPackage'.
		self assert: targetObject instanceSlotNames asArray equals: #('alpha' 'beta').
		self assert: targetObject classVariableNames asArray equals: #('SharedValue').
		self assert: targetObject superclassName equals: 'Object'.
		self assert: targetObject packageName equals: 'Gt4LlmCoreNewPackage'
	] ensure: [ self removeClassNamedIfPresent: className ].
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changePackageWithPartialArguments [
	<gtExample>
	| className call |
	
	className := #GtLMagritteToolForClassSignatureChangeExamplesPartialPkg.
	self removeClassNamedIfPresent: className.
	[
		| targetClass targetObject |
		targetClass := ((Object
			<< className)
			slots: { #first . #second };
			sharedVariables: { #SharedValue };
			package: 'Gt4LlmCoreNewPackage') install.
		call := self
			executeTool: GtLMagritteToolForClassDefinitionChange new
			withArguments: {
				'classChangeRequest' -> {
					'targetClassName' -> className.
					'package' -> 'Gt4LlmCoreNewPackage2'
				} asDictionary
			} asDictionary.
		targetObject := call result targetObject.
		
		self assert: (targetObject isKindOf: GtLClassModificationResult).
		self assert: (targetClass instanceVariables collect: #name) equals: #('first' 'second').
		self assert: (targetClass classVariables collect: #name) equals: #('SharedValue').
		self assert: targetClass superclass equals: Object.
		self assert: targetClass package name equals: 'Gt4LlmCoreNewPackage2'.
		self assert: targetObject instanceSlotNames asArray equals: #('first' 'second').
		self assert: targetObject classVariableNames asArray equals: #('SharedValue').
		self assert: targetObject superclassName equals: 'Object'.
		self assert: targetObject packageName equals: 'Gt4LlmCoreNewPackage2'
	] ensure: [ self removeClassNamedIfPresent: className ].
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changeSuperclassWithPartialArguments [
	<gtExample>
	| className call |
	
	className := #GtLMagritteToolForClassSignatureChangeExamplesPartialSuper.
	self removeClassNamedIfPresent: className.
	[
		| targetClass targetObject |
		targetClass := ((Object
			<< className)
			slots: { #first . #second };
			sharedVariables: { #SharedValue };
			package: 'Gt4LlmCoreNewPackage') install.
		call := self
			executeTool: GtLMagritteToolForClassDefinitionChange new
			withArguments: {
				'classChangeRequest' -> {
					'targetClassName' -> className.
					'superclassName' -> 'Exception'
				} asDictionary
			} asDictionary.
		targetObject := call result targetObject.
		
		self assert: (targetObject isKindOf: GtLClassModificationResult).
		self assert: (targetClass instanceVariables collect: #name) equals: #('first' 'second').
		self assert: (targetClass classVariables collect: #name) equals: #('SharedValue').
		self assert: targetClass superclass equals: Exception.
		self assert: targetClass package name equals: 'Gt4LlmCoreNewPackage'.
		self assert: targetObject instanceSlotNames asArray equals: #('first' 'second').
		self assert: targetObject classVariableNames asArray equals: #('SharedValue').
		self assert: targetObject superclassName equals: 'Exception'.
		self assert: targetObject packageName equals: 'Gt4LlmCoreNewPackage'
	] ensure: [ self removeClassNamedIfPresent: className ].
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changeUnknownClass [
	<gtExample>
	| call className |
	
	className := #GtLMagritteToolForClassSignatureChangeExamplesMissing.
	self removeClassNamedIfPresent: className.
	call := self
		executeTool: GtLMagritteToolForClassDefinitionChange new
		withArguments: {
			'classChangeRequest' -> {
				'targetClassName' -> className.
				'superclassName' -> #Object.
				'instanceVariables' -> #().
				'classVariables' -> #().
				'package' -> 'Gt4LlmCoreNewPackage'
			} asDictionary
		} asDictionary.
	
	self
		assertMissingObject: call result targetObject
		withObjectName: className asString
		errorMessage: className asString, ' is not found'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changeWithMissingClassChangeRequest [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassDefinitionChange new
		withArguments: Dictionary new.
	
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('classChangeRequest')
		path: #(nil)
		errorMessage: 'required properties missing [classChangeRequest]'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changeWithMissingTargetClassName [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassDefinitionChange new
		withArguments: {
			'classChangeRequest' -> {
				'superclassName' -> 'Object'.
				'package' -> 'SomePackage'
			} asDictionary
		} asDictionary.
	
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('targetClassName')
		path: #('classChangeRequest')
		errorMessage: '@[classChangeRequest] required properties missing [targetClassName]'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changeWithNilClassChangeRequest [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassDefinitionChange new
		withArguments: {
			'classChangeRequest' -> nil
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('classChangeRequest')
		errorMessage: '@[classChangeRequest] object expected'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changeWithNilTargetClassName [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassDefinitionChange new
		withArguments: {
			'classChangeRequest' -> {
				'targetClassName' -> nil.
				'superclassName' -> 'Object'.
				'package' -> 'SomePackage'
			} asDictionary
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #(#classChangeRequest #targetClassName)
		errorMessage: '@[classChangeRequest/targetClassName] string expected'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changeWithUnknownSuperclass [
	<gtExample>
	| className call |
	
	className := #GtLMagritteToolForClassSignatureChangeExamplesUnknownSuper.
	self removeClassNamedIfPresent: className.
	[
		| targetClass |
		targetClass := ((Object
			<< className)
			slots: {};
			package: 'Gt4LlmCoreNewPackage') install.
		call := self
			executeTool: GtLMagritteToolForClassDefinitionChange new
			withArguments: {
				'classChangeRequest' -> {
					'targetClassName' -> className.
					'superclassName' -> 'NonExistentSuperclass42'
				} asDictionary
			} asDictionary.
		
		self
			assertMissingObject: call result targetObject
			withObjectName: 'NonExistentSuperclass42'
			errorMessage: 'NonExistentSuperclass42 is not found'
	] ensure: [ self removeClassNamedIfPresent: className ].
		
	^ call
]

{ #category : #private }
GtLMagritteToolForClassDefinitionChangeExamples >> removeClassNamedIfPresent: aSymbol [
	Smalltalk globals
		at: aSymbol asSymbol
		ifPresent: [ :cls | cls removeFromSystem ]
]
