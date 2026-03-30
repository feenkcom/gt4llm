"
Examples for GtLMagritteToolForClassDefinitionChange.
"
Class {
	#name : #GtLMagritteToolForClassDefinitionChangeExamples,
	#superclass : #Object,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changeClassInstanceVariables [
	<gtExample>
	|  call className |
	[ |tool result model targetClass|
	className := #GtLMagritteToolForClassSignatureChangeExamplesWithIvars.
	self removeClassNamedIfPresent: className.
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: (model isKindOf: GtLClassModificationResult).
	self assert: (targetClass instanceVariables collect: #name) = #('alpha' 'beta').
	self assert: model instanceSlotNames asArray equals: #('alpha' 'beta') ]
	ensure: [ self removeClassNamedIfPresent: className ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changeClassVariablesWithPartialArguments [
	<gtExample>
	| className call |
	[ | tool result model targetClass |
	className := #GtLMagritteToolForClassSignatureChangeExamplesPartialCvars.
	self removeClassNamedIfPresent: className.
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	
	self assert: (model isKindOf: GtLClassModificationResult).
	self assert: (targetClass instanceVariables collect: #name) equals: #('first' 'second').
	self assert: (targetClass classVariables collect: #name) asSet equals: #('NewShared' 'AnotherShared') asSet.
	self assert: targetClass superclass equals: Object.
	self assert: targetClass package name equals: 'Gt4LlmCoreNewPackage'.
	self assert: model instanceSlotNames asArray equals: #('first' 'second').
	self assert: model classVariableNames asSet equals: #('NewShared' 'AnotherShared') asSet.
	self assert: model superclassName equals: 'Object'.
	self assert: model packageName equals: 'Gt4LlmCoreNewPackage' ]
	ensure: [ self removeClassNamedIfPresent: className ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changeInstanceVariablesWithPartialArguments [
	<gtExample>
	|  className call |
	[ |tool result model targetClass|
	className := #GtLMagritteToolForClassSignatureChangeExamplesPartial.
	self removeClassNamedIfPresent: className.
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	
	self assert: (model isKindOf: GtLClassModificationResult).
	self assert: (targetClass instanceVariables collect: #name) = #('alpha' 'beta').
	self assert: (targetClass classVariables collect: #name) = #('SharedValue').
	self assert: targetClass superclass equals: Object.
	self assert: targetClass package name equals: 'Gt4LlmCoreNewPackage'.
	self assert: model instanceSlotNames asArray equals: #('alpha' 'beta').
	self assert: model classVariableNames asArray equals: #('SharedValue').
	self assert: model superclassName equals: 'Object'.
	self assert: model packageName equals: 'Gt4LlmCoreNewPackage' ]
	ensure: [ self removeClassNamedIfPresent: className ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changePackageWithPartialArguments [
	<gtExample>
	| className call |
	[ | tool result model targetClass |
	className := #GtLMagritteToolForClassSignatureChangeExamplesPartialPkg.
	self removeClassNamedIfPresent: className.
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	
	self assert: (model isKindOf: GtLClassModificationResult).
	self assert: (targetClass instanceVariables collect: #name) equals: #('first' 'second').
	self assert: (targetClass classVariables collect: #name) equals: #('SharedValue').
	self assert: targetClass superclass equals: Object.
	self assert: targetClass package name equals: 'Gt4LlmCoreNewPackage2'.
	self assert: model instanceSlotNames asArray equals: #('first' 'second').
	self assert: model classVariableNames asArray equals: #('SharedValue').
	self assert: model superclassName equals: 'Object'.
	self assert: model packageName equals: 'Gt4LlmCoreNewPackage2' ]
	ensure: [ self removeClassNamedIfPresent: className ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changeSuperclassWithPartialArguments [
	<gtExample>
	| className call |
	[ | tool result model targetClass |
	className := #GtLMagritteToolForClassSignatureChangeExamplesPartialSuper.
	self removeClassNamedIfPresent: className.
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	
	self assert: (model isKindOf: GtLClassModificationResult).
	self assert: (targetClass instanceVariables collect: #name) equals: #('first' 'second').
	self assert: (targetClass classVariables collect: #name) equals: #('SharedValue').
	self assert: targetClass superclass equals: Exception.
	self assert: targetClass package name equals: 'Gt4LlmCoreNewPackage'.
	self assert: model instanceSlotNames asArray equals: #('first' 'second').
	self assert: model classVariableNames asArray equals: #('SharedValue').
	self assert: model superclassName equals: 'Exception'.
	self assert: model packageName equals: 'Gt4LlmCoreNewPackage' ]
	ensure: [ self removeClassNamedIfPresent: className ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changeUnknownClass [
	<gtExample>
	| tool call result model className |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: model objectName equals: className asString.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changeWithMissingClassChangeRequest [
	<gtExample>
	| tool call result model |
	tool := GtLMagritteToolForClassDefinitionChange new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: model class equals: GtLMissingRequiredPropertiesDomainObject.
	self assert: model missingPropertyNames equals: #('classChangeRequest').
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassDefinitionChangeExamples >> changeWithMissingTargetClassName [
	<gtExample>
	| tool call result model |
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
	self assert: (result isKindOf: GtLMagritteBasedModel).
	model := result model.
	self assert: model isErrorDomainObject.
	self assert: model class equals: GtLMissingRequiredPropertiesDomainObject.
	self assert: (model missingPropertyNames includes: 'targetClassName').
	^ call
]

{ #category : #private }
GtLMagritteToolForClassDefinitionChangeExamples >> removeClassNamedIfPresent: aSymbol [
	Smalltalk globals
		at: aSymbol asSymbol
		ifPresent: [ :cls | cls removeFromSystem ]
]
