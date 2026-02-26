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
GtLToolForClassDefinitionChangeExamples >> changeClassVariablesWithPartialArguments [
	<gtExample>
	| tool call result className targetClass |
	[ className := #GtLToolForClassSignatureChangeExamplesPartialClassVars.
	self removeClassNamedIfPresent: className.
	targetClass := (Object << className
		slots: {'first'};
		classSlots: {'OldShared'};
		package: 'Gt4LlmCoreNewPackage') install.
	tool := GtLToolForClassDefinitionChange new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> className.
			'classVariables' -> #('NewShared' 'SharedValue')} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result foundClass equals: targetClass.
	self assert: (targetClass instanceVariables collect: #name) = #('first').
	self assert: (targetClass classVariables collect: #name) = #('NewShared' 'SharedValue').
	self assert: targetClass superclass equals: Object.
	self assert: targetClass package name equals: 'Gt4LlmCoreNewPackage'.
	self assert: result originalInstanceVariableNames equals: 'first'.
	self assert: result originalClassVariableNames equals: 'NewShared SharedValue'.
	self assert: result originalSuperclassName equals: 'Object'.
	self assert: result originalPackageName equals: 'Gt4LlmCoreNewPackage' ]
		ensure: [ self removeClassNamedIfPresent: className ].
	^ call
]

{ #category : #examples }
GtLToolForClassDefinitionChangeExamples >> changeInstanceVariablesWithPartialArguments [
	<gtExample>
	| tool call result className targetClass |
	[ className := #GtLToolForClassSignatureChangeExamplesPartial.
	self removeClassNamedIfPresent: className.
	targetClass := Object
		subclass: className
		instanceVariableNames: 'first second'
		classVariableNames: 'SharedValue'
		package: 'Gt4LlmCoreNewPackage'.
	tool := GtLToolForClassDefinitionChange new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> className.
			'instanceVariables' -> #('alpha' 'beta')} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result foundClass equals: targetClass.
	self assert: (targetClass instanceVariables collect: #name) = #('alpha' 'beta').
	self assert: (targetClass classVariables collect: #name) = #('SharedValue').
	self assert: targetClass superclass equals: Object.
	self assert: targetClass package name equals: 'Gt4LlmCoreNewPackage'.
	self assert: result originalInstanceVariableNames equals: 'alpha beta'.
	self assert: result originalClassVariableNames equals: 'SharedValue'.
	self assert: result originalSuperclassName equals: 'Object'.
	self assert: result originalPackageName equals: 'Gt4LlmCoreNewPackage' ]
		ensure: [ self removeClassNamedIfPresent: className ].
	^ call
]

{ #category : #examples }
GtLToolForClassDefinitionChangeExamples >> changePackageWithPartialArguments [
	<gtExample>
	| tool call result className targetClass |
	[ className := #GtLToolForClassSignatureChangeExamplesPartialPackage.
	self removeClassNamedIfPresent: className.
	targetClass := Object
		subclass: className
		instanceVariableNames: 'first'
		classVariableNames: 'SharedValue'
		package: 'Gt4LlmCoreNewPackage'.
	tool := GtLToolForClassDefinitionChange new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> className.
			'package' -> 'Gt4LlmCoreNewPackage2'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result foundClass equals: targetClass.
	self assert: (targetClass instanceVariables collect: #name) = #('first').
	self assert: (targetClass classVariables collect: #name) = #('SharedValue').
	self assert: targetClass superclass equals: Object.
	self assert: targetClass package name equals: 'Gt4LlmCoreNewPackage2'.
	self assert: result originalInstanceVariableNames equals: 'first'.
	self assert: result originalClassVariableNames equals: 'SharedValue'.
	self assert: result originalSuperclassName equals: 'Object'.
	self assert: result originalPackageName equals: 'Gt4LlmCoreNewPackage2' ]
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
GtLToolForClassDefinitionChangeExamples >> changeSuperclassWithPartialArguments [
	<gtExample>
	| tool call result baseClassName newBaseClassName className baseClass newBaseClass targetClass |
	[ baseClassName := #GtLToolForClassSignatureChangeExamplesPartialBase1.
	newBaseClassName := #GtLToolForClassSignatureChangeExamplesPartialBase2.
	className := #GtLToolForClassSignatureChangeExamplesPartialTarget.
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
		instanceVariableNames: 'alpha'
		classVariableNames: 'SharedValue'
		package: 'Gt4LlmCoreNewPackage'.
	tool := GtLToolForClassDefinitionChange new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {
			'className' -> className.
			'superclassName' -> newBaseClassName} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: targetClass superclass equals: newBaseClass.
	self assert: (targetClass instanceVariables collect: #name) = #('alpha').
	self assert: (targetClass classVariables collect: #name) = #('SharedValue').
	self assert: targetClass package name equals: 'Gt4LlmCoreNewPackage'.
	self assert: result originalSuperclassName equals: newBaseClassName asString.
	self assert: result originalInstanceVariableNames equals: 'alpha'.
	self assert: result originalClassVariableNames equals: 'SharedValue'.
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
