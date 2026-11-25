"
I show the RenameClass transformation ({{gtClass:GtLRenameClassSpecification}}): its problems, its name and description, and that it groups the changes of a preview.
"
Class {
	#name : #GtLRenameClassSpecificationExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #private }
GtLRenameClassSpecificationExamples >> assertSpecification: aSpecification hasProblem: aString [
	| problems |
	problems := aSpecification gtProblems.
	self
		assert: (problems collect: [ :each | each description ]) asArray
		equals: {aString}.
	^ problems
]

{ #category : #examples }
GtLRenameClassSpecificationExamples >> refuseClassSide [
	<gtExample>
	^ self
		assertSpecification: (self
				specificationRenaming: 'GtLRenameClassSpecificationExamples class'
				to: 'GtLRenamedClass')
		hasProblem: 'GtLRenameClassSpecificationExamples class is the class side of GtLRenameClassSpecificationExamples. Rename GtLRenameClassSpecificationExamples instead.'
]

{ #category : #examples }
GtLRenameClassSpecificationExamples >> refuseInvalidNewClassName [
	<gtExample>
	^ self
		assertSpecification: (self
				specificationRenaming: 'GtLRenameClassSpecificationExamples'
				to: 'renamed class')
		hasProblem: 'renamed class is not a valid class name: it must start with an uppercase letter and contain only letters, digits and underscores'
]

{ #category : #examples }
GtLRenameClassSpecificationExamples >> refuseMissingClassName [
	<gtExample>
	^ self
		assertSpecification: (self specificationRenaming: '' to: 'GtLRenamedClass')
		hasProblem: 'Missing class name'
]

{ #category : #examples }
GtLRenameClassSpecificationExamples >> refuseMissingNewClassName [
	<gtExample>
	^ self
		assertSpecification: (self specificationRenaming: 'GtLRenameClassSpecificationExamples' to: nil)
		hasProblem: 'Missing new class name'
]

{ #category : #examples }
GtLRenameClassSpecificationExamples >> refuseOtherNameOfClass [
	"A global can hold a class under another name, for example a deprecated name"

	<gtExample>
	| problems |
	[ Smalltalk globals
		at: #GtLRenameClassSpecificationExamplesAlias
		put: GtLRenameClassSpecificationExamples.
	problems := self
			assertSpecification: (self
					specificationRenaming: 'GtLRenameClassSpecificationExamplesAlias'
					to: 'GtLRenamedClass')
			hasProblem: 'GtLRenameClassSpecificationExamplesAlias is another name of GtLRenameClassSpecificationExamples. Rename a class by its own name.' ]
		ensure: [ Smalltalk globals
				removeKey: #GtLRenameClassSpecificationExamplesAlias
				ifAbsent: [  ] ].
	^ problems
]

{ #category : #examples }
GtLRenameClassSpecificationExamples >> refuseSameName [
	<gtExample>
	^ self
		assertSpecification: (self
				specificationRenaming: 'GtLRenameClassSpecificationExamples'
				to: 'GtLRenameClassSpecificationExamples')
		hasProblem: 'The new class name is the current name of the class: GtLRenameClassSpecificationExamples'
]

{ #category : #examples }
GtLRenameClassSpecificationExamples >> refuseUnknownClass [
	<gtExample>
	^ self
		assertSpecification: (self specificationRenaming: 'GtLNoSuchClassToRename' to: 'GtLRenamedClass')
		hasProblem: 'Class not found: GtLNoSuchClassToRename'
]

{ #category : #examples }
GtLRenameClassSpecificationExamples >> refuseUsedNewClassName [
	<gtExample>
	^ self
		assertSpecification: (self
				specificationRenaming: 'GtLRenameClassSpecificationExamples'
				to: 'Smalltalk')
		hasProblem: 'Smalltalk is already the name of a class or global variable'
]

{ #category : #private }
GtLRenameClassSpecificationExamples >> specificationRenaming: aClassName to: aNewClassName [
	^ GtLRenameClassSpecification new
		className: aClassName;
		newClassName: aNewClassName;
		yourself
]

{ #category : #examples }
GtLRenameClassSpecificationExamples >> transformationsGroupTheChanges [
	"All changes are reported by one preview, in the groups of all the transformations; without groups, one by one"

	<gtExample>
	| transformations |
	transformations := GtLCodeTransformations new
			transformations: {GtLAddMethodSpecification new}.
	self assert: transformations changeGroupNames isEmpty.
	transformations := GtLCodeTransformations new
			transformations: {GtLAddMethodSpecification new.
					self validSpecification.
					GtLRemoveMethodSpecification new}.
	self
		assert: transformations changeGroupNames
		equals: #('classChanges' 'methodChanges' 'lepiterChanges').
	^ transformations
]

{ #category : #examples }
GtLRenameClassSpecificationExamples >> transformationsOnTheRenamedClassComeFirst [
	"The transformations of a call run in order, but are checked against the image as it is. After a RenameClass, a transformation can name the class neither by its old name, also on the class side, nor by its new one; before the RenameClass, with the current name, it is valid"

	<gtExample>
	| addMethod rename afterRename onNewName onClassSide beforeRename |
	addMethod := [ :aClassName | 
		GtLAddMethodSpecification new
			methodClassName: aClassName;
			protocolName: 'examples';
			sourceCode: 'addedMethod ^ 42';
			yourself ].
	rename := self validSpecification.
	afterRename := GtLCodeTransformations new
			transformations: {rename.
					addMethod value: 'GtLRenameClassSpecificationExamples'}.
	self
		assert: (afterRename orderProblems collect: [ :each | each description ]) asArray
		equals: #('AddMethod on GtLRenameClassSpecificationExamples comes after the RenameClass of GtLRenameClassSpecificationExamples: put it before the RenameClass, with the current name').
	onClassSide := GtLCodeTransformations new
			transformations: {rename.
					addMethod value: 'GtLRenameClassSpecificationExamples class'}.
	self assert: onClassSide orderProblems size equals: 1.
	onNewName := GtLCodeTransformations new
			transformations: {rename.
					addMethod value: 'GtLRenameClassSpecificationExamplesRenamed'}.
	self
		assert: (onNewName orderProblems collect: [ :each | each description ]) asArray
		equals: #('AddMethod names GtLRenameClassSpecificationExamplesRenamed, the new name of GtLRenameClassSpecificationExamples: put it before the RenameClass, with the current name GtLRenameClassSpecificationExamples').
	beforeRename := GtLCodeTransformations new
			transformations: {addMethod value: 'GtLRenameClassSpecificationExamples'.
					rename}.
	self assert: beforeRename gtProblems isEmpty.
	^ afterRename
]

{ #category : #examples }
GtLRenameClassSpecificationExamples >> validSpecification [
	<gtExample>
	| aSpecification |
	aSpecification := self
			specificationRenaming: 'GtLRenameClassSpecificationExamples'
			to: 'GtLRenameClassSpecificationExamplesRenamed'.
	self assert: aSpecification gtProblems isEmpty.
	self assert: aSpecification refactoringName equals: 'Rename class'.
	self
		assert: aSpecification refactoringDescription
		equals: 'Rename class GtLRenameClassSpecificationExamples to GtLRenameClassSpecificationExamplesRenamed'.
	self
		assert: aSpecification changeGroupNames
		equals: #('classChanges' 'methodChanges' 'lepiterChanges').
	self assert: GtLRenameClassSpecification jsonSchemaLabel equals: 'RenameClass'.
	self assert: GtLRenameClassSpecification isConcrete.
	^ aSpecification
]
