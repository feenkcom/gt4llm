"
I show the problems of the RenameMethod transformation ({{gtClass:GtLRenameMethodSpecification}}): those found from its parameters alone, and those found in the image, which the refactoring engine would report without naming the class or would not report at all. Checking the problems changes nothing; {{gtClass:GtLMagritteToolForMethodRenameExamples}} shows renames applied to temporary classes.
"
Class {
	#name : #GtLRenameMethodSpecificationExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLRenameMethodSpecificationExamples >> parameterProblems [
	"Missing names, a class side named as a class, an unchanged or invalid name and a different number of arguments are found from the parameters alone. The refactoring engine accepts the last one and writes broken code"

	<gtExample>
	| problemsOf |
	problemsOf := [ :aClassName :aName :aNewName | 
		self
			problemDescriptionsOf: (self
					specificationOf: aClassName
					classSide: false
					renaming: aName
					to: aNewName) ].
	self
		assert: (problemsOf
				value: ''
				value: 'foo:'
				value: 'bar:')
		equals: #('Missing class name').
	self
		assert: (problemsOf
				value: 'Object class'
				value: 'foo:'
				value: 'bar:')
		equals: #('Object class is the class side of Object: name Object and set classSide to true').
	self
		assert: (problemsOf
				value: 'Object'
				value: ''
				value: 'bar:')
		equals: #('Missing method name').
	self
		assert: (problemsOf
				value: 'Object'
				value: 'foo:'
				value: '')
		equals: #('Missing new method name').
	self
		assert: (problemsOf
				value: 'Object'
				value: 'foo:'
				value: 'foo:')
		equals: #('The new method name is the current name of the method: foo:').
	self
		assert: (problemsOf
				value: 'Object'
				value: 'foo:'
				value: 'two words')
		equals: #('two words is not a valid method name').
	self
		assert: (problemsOf
				value: 'Object'
				value: 'foo:'
				value: 'bar')
		equals: #('foo: takes 1 argument and bar takes 0 arguments: a rename keeps the arguments, so the new method name must take as many').
	self
		assert: (problemsOf
				value: 'Object'
				value: 'at:put:'
				value: 'at:')
		equals: #('at:put: takes 2 arguments and at: takes 1 argument: a rename keeps the arguments, so the new method name must take as many').
	^ problemsOf
]

{ #category : #examples }
GtLRenameMethodSpecificationExamples >> preconditionProblems [
	"The method must be defined in the class itself, not inherited or provided by a trait. No trait composition may alias or exclude the selector: the refactoring engine does not change compositions. The new selector must not be defined in the hierarchy of an implementor: here Object defines printOn:"

	<gtExample>
	| problemsOf |
	problemsOf := [ :aClassName :aName :aNewName | 
		self
			problemDescriptionsOf: (self
					specificationOf: aClassName
					classSide: false
					renaming: aName
					to: aNewName) ].
	self
		assert: (problemsOf
				value: 'GtLNoSuchClassToRename'
				value: 'foo'
				value: 'bar')
		equals: #('Class not found: GtLNoSuchClassToRename').
	self
		assert: (problemsOf
				value: 'GtLRenameMethodSpecificationExamples'
				value: 'printString'
				value: 'printText')
		equals: #('GtLRenameMethodSpecificationExamples>>#printString is not defined in its own class: it is inherited. Its source is Object>>#printString').
	self
		assert: (problemsOf
				value: 'GtLExampleTraitUser'
				value: 'traitMethod'
				value: 'renamedTraitMethod')
		equals: #('GtLExampleTraitUser>>#traitMethod is not defined in its own class: it is provided by a trait. Its source is TGtLExampleTrait>>#traitMethod').
	self
		assert: (problemsOf
				value: 'TGtLExampleTrait'
				value: 'traitMethod'
				value: 'renamedTraitMethod')
		equals: #('The trait compositions of GtLExampleTraitUser alias or exclude traitMethod, and the rename does not change trait compositions. Change these compositions first').
	self
		assert: (problemsOf
				value: 'GtLRenameMethodSpecificationExamples'
				value: 'problemDescriptionsOf:'
				value: 'printOn:')
		equals: #('printOn: is already defined in the hierarchy of an implementor of problemDescriptionsOf:, which the rename renames: GtLRenameMethodSpecificationExamples (printOn: in Object). The renamed methods would override these methods or be overridden by them').
	^ problemsOf
]

{ #category : #private }
GtLRenameMethodSpecificationExamples >> problemDescriptionsOf: aSpecification [
	^ (aSpecification gtProblems collect: [ :each | each description ]) asArray
]

{ #category : #private }
GtLRenameMethodSpecificationExamples >> specificationOf: aClassName classSide: aBoolean renaming: aName to: aNewName [
	^ GtLRenameMethodSpecification new
		methodClassName: aClassName;
		classSide: aBoolean;
		methodNameToRename: aName;
		newMethodName: aNewName;
		yourself
]

{ #category : #examples }
GtLRenameMethodSpecificationExamples >> validSpecification [
	"Renaming a method of this class that no other class implements has no problems"

	<gtExample>
	| specification |
	specification := self
			specificationOf: 'GtLRenameMethodSpecificationExamples'
			classSide: false
			renaming: 'problemDescriptionsOf:'
			to: 'problemDescriptionsFor:'.
	self assert: specification gtProblems isEmpty.
	self assert: specification refactoringName equals: 'Rename method'.
	self
		assert: specification refactoringDescription
		equals: 'Rename method GtLRenameMethodSpecificationExamples>>#problemDescriptionsOf: to problemDescriptionsFor:'.
	self
		assert: specification changeGroupNames
		equals: #('methodChanges' 'lepiterChanges').
	^ specification
]
