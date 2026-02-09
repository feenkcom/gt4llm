Class {
	#name : #GtLToolForClassDefinitionChangeExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLToolForClassDefinitionChangeExamples >> changeClassInstanceVariables [
	<gtExample>
	| tool call result className targetClass |
	[ className := #GtLToolForClassSignatureChangeExamplesWithIvars.
	self removeClassNamedIfPresent: className.
	targetClass := (Object <<className
		slots: {'first'};
		classSlots: {};
		package: 'Gt4LlmCoreNewPackage') install.
	tool := GtLToolForClassDefinitionChange new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> className.
			'superclassName' -> #Object.
			'instanceVariables' -> #('alpha' 'beta').
			'classVariables' -> #().
			'package' -> 'Gt4LlmCoreNewPackage'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result foundClass equals: targetClass.
	self assert: (targetClass instanceVariables collect: #name) = #('alpha' 'beta').
	self assert: result originalInstanceVariableNames equals: 'alpha beta' ]
		ensure: [ self removeClassNamedIfPresent: className ].
	^ call
]

{ #category : #examples }
GtLToolForClassDefinitionChangeExamples >> changeClassVariables [
	<gtExample>
	| tool call result className targetClass |
	[ className := #GtLToolForClassSignatureChangeExamplesWithClassVars.
	self removeClassNamedIfPresent: className.
	targetClass := (Object <<className
		slots: {};
		classSlots: {'OldCounter'};
		package: 'Gt4LlmCoreNewPackage') install.
	tool := GtLToolForClassDefinitionChange new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> className.
			'superclassName' -> #Object.
			'instanceVariables' -> ''.
			'classVariables' -> #('NewCounter' 'SharedValue').
			'package' -> 'Gt4LlmCoreNewPackage'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result foundClass equals: targetClass.
	self assert: (targetClass classVariables collect: #name) = #('NewCounter' 'SharedValue').
	self assert: result originalClassVariableNames equals: 'NewCounter SharedValue' ]
		ensure: [ self removeClassNamedIfPresent: className ].
	^ call
]

{ #category : #examples }
GtLToolForClassDefinitionChangeExamples >> changeSuperclassAndPackage [
	<gtExample>
	| tool call result baseClassName newBaseClassName className baseClass newBaseClass targetClass |
	[ baseClassName := #GtLToolForClassSignatureChangeExamplesBase1.
	newBaseClassName := #GtLToolForClassSignatureChangeExamplesBase2.
	className := #GtLToolForClassSignatureChangeExamplesTarget.
	self removeClassNamedIfPresent: className.
	self removeClassNamedIfPresent: baseClassName.
	self removeClassNamedIfPresent: newBaseClassName.
	baseClass := Object
		subclass: baseClassName
		instanceVariableNames: ''
		classVariableNames: ''
		package: 'Gt4LlmCoreNewPackage'.
	newBaseClass := Object
		subclass: newBaseClassName
		instanceVariableNames: ''
		classVariableNames: ''
		package: 'Gt4LlmCoreNewPackage'.
	targetClass := baseClass
		subclass: className
		instanceVariableNames: ''
		classVariableNames: ''
		package: 'Gt4LlmCoreNewPackage'.
	tool := GtLToolForClassDefinitionChange new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> className.
			'superclassName' -> newBaseClassName.
			'instanceVariables' -> ''.
			'classVariables' -> ''.
			'package' -> 'Gt4LlmCoreNewPackage'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: targetClass superclass equals: newBaseClass.
	self assert: targetClass package name equals: 'Gt4LlmCoreNewPackage'.
	self assert: result originalSuperclassName equals: newBaseClassName asString.
	self assert: result originalPackageName equals: 'Gt4LlmCoreNewPackage' ]
		ensure: [
			self removeClassNamedIfPresent: className.
			self removeClassNamedIfPresent: baseClassName.
			self removeClassNamedIfPresent: newBaseClassName ].
	^ call
]

{ #category : #examples }
GtLToolForClassDefinitionChangeExamples >> changeUnknownClass [
	<gtExample>
	| tool call result className |
	className := #GtLToolForClassSignatureChangeExamplesMissing.
	self removeClassNamedIfPresent: className.
	tool := GtLToolForClassDefinitionChange new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> className.
			'superclassName' -> #Object.
			'instanceVariables' -> ''.
			'classVariables' -> ''.
			'package' -> 'Gt4LlmCoreNewPackage'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject.
	self assert: result objectName equals: className asString.
	^ call
]

{ #category : #private }
GtLToolForClassDefinitionChangeExamples >> removeClassNamedIfPresent: aSymbol [
	Smalltalk globals
		at: aSymbol asSymbol
		ifPresent: [ :cls | cls removeFromSystem ]
]
