"
I show how method references resolve methods that a class gets from traits: copies, aliases, composed traits, class traits, requirements and conflicts. Read-only cases use the static subjects such as GtLExampleTraitUser; cases that need invalid trait states use the temporary subjects of GtLTraitMethodExamplesSubjects. GtLMethodReferenceExamples covers references to methods of ordinary classes.
"
Class {
	#name : #GtLMethodReferenceTraitExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLMethodReferenceTraitExamples >> aliasedComposedConflictingTraitMethodReferenceMissingDomainObject [
	"An alias of a conflict from a composed trait names the conflicting trait methods under their original selector"

	<gtExample>
	<return: #GtLMissingTraitConflictMethodDomainObject>
	^ GtLTraitMethodExamplesSubjects new
		during: [ :subjects | 
			| domainObject |
			domainObject := self
					resolveMethod: #aliasedConflictingTraitMethod
					inClassNamed: subjects conflictingComposedTraitUser name
					classSide: false.
			self
				assert: domainObject class
				equals: GtLMissingTraitConflictMethodDomainObject.
			self
				assert: domainObject conflictLocationReference
				equals: (GtLMethodReference
						fromCompiledMethod: subjects conflictingComposedTrait >> #traitMethod).
			self assert: domainObject conflictingMethodReferences size equals: 2.
			domainObject ]
]

{ #category : #examples }
GtLMethodReferenceTraitExamples >> aliasedTraitMethodInCompositionReferenceMissingDomainObject [
	"An alias inside a composition of several traits still names the trait method under its original selector"

	<gtExample>
	<return: #GtLMissingTraitMethodDomainObject>
	^ GtLTraitMethodExamplesSubjects new
		during: [ :subjects | 
			| domainObject |
			domainObject := self
					resolveMethod: #sequenceAliasedTraitMethod
					inClassNamed: subjects conflictingTraitsUser name
					classSide: false.
			self assert: domainObject class equals: GtLMissingTraitMethodDomainObject.
			self
				assert: domainObject definingMethodReference
				equals: (GtLMethodReference fromCompiledMethod: subjects trait >> #traitMethod).
			domainObject ]
]

{ #category : #examples }
GtLMethodReferenceTraitExamples >> aliasedTraitMethodReferenceMissingDomainObject [
	"An alias in the trait composition names the trait method under its original selector"

	<gtExample>
	<return: #GtLMissingTraitMethodDomainObject>
	| domainObject |
	domainObject := self
			resolveMethod: #aliasedTraitMethod
			inClassNamed: GtLExampleTraitUser name
			classSide: false.
	self assert: domainObject class equals: GtLMissingTraitMethodDomainObject.
	self
		assert: domainObject definingMethodReference
		equals: (GtLMethodReference fromCompiledMethod: TGtLExampleTrait >> #traitMethod).
	^ domainObject
]

{ #category : #examples }
GtLMethodReferenceTraitExamples >> classSideTraitMethodReferenceMissingDomainObject [
	<gtExample>
	<return: #GtLMissingTraitMethodDomainObject>
	| domainObject |
	domainObject := self
			resolveMethod: #classTraitMethod
			inClassNamed: GtLExampleTraitUser name
			classSide: true.
	self assert: domainObject class equals: GtLMissingTraitMethodDomainObject.
	self
		assert: domainObject definingMethodReference methodClassName
		equals: TGtLExampleTrait name asString.
	self assert: domainObject definingMethodReference isClassSide.
	self
		assert: domainObject errorMessage
		equals: 'GtLExampleTraitUser class>>#classTraitMethod is not defined in its own class: it is provided by a trait. Its source is TGtLExampleTrait class>>#classTraitMethod'.
	^ domainObject
]

{ #category : #examples }
GtLMethodReferenceTraitExamples >> composedConflictingTraitMethodReferenceMissingDomainObject [
	"A conflict that a class gets from a trait composed of conflicting traits names that trait, where the traits conflict"

	<gtExample>
	<return: #GtLMissingTraitConflictMethodDomainObject>
	^ GtLTraitMethodExamplesSubjects new
		during: [ :subjects | 
			| domainObject |
			domainObject := self
					resolveMethod: #traitMethod
					inClassNamed: subjects conflictingComposedTraitUser name
					classSide: false.
			self
				assert: domainObject class
				equals: GtLMissingTraitConflictMethodDomainObject.
			self
				assert: domainObject conflictLocationReference
				equals: (GtLMethodReference
						fromCompiledMethod: subjects conflictingComposedTrait >> #traitMethod).
			self
				assert: domainObject conflictingMethodReferences asArray
				equals: {GtLMethodReference fromCompiledMethod: subjects trait >> #traitMethod.
						GtLMethodReference
							fromCompiledMethod: subjects conflictingTrait >> #traitMethod}.
			self
				assert: domainObject errorMessage
				equals: ('{1}>>#traitMethod is not defined in its own class: it comes from {2}>>#traitMethod, where several traits conflict ({3}>>#traitMethod, {4}>>#traitMethod). Define it in the class, or resolve the conflict at {2}>>#traitMethod.'
						format: {subjects conflictingComposedTraitUser name.
								subjects conflictingComposedTrait name.
								subjects trait name.
								subjects conflictingTrait name}).
			domainObject ]
]

{ #category : #examples }
GtLMethodReferenceTraitExamples >> composedTraitMethodReferenceMissingDomainObject [
	"A method that reaches a class through a trait that uses another trait is defined in that other trait"

	<gtExample>
	<return: #GtLMissingTraitMethodDomainObject>
	| traitDefinition userObject composedTraitObject |
	traitDefinition := GtLMethodReference
			fromCompiledMethod: TGtLExampleTrait >> #traitMethod.
	userObject := self
			resolveMethod: #traitMethod
			inClassNamed: GtLExampleComposedTraitUser name
			classSide: false.
	composedTraitObject := self
			resolveMethod: #traitMethod
			inClassNamed: TGtLExampleComposedTrait name
			classSide: false.
	self assert: userObject class equals: GtLMissingTraitMethodDomainObject.
	self assert: userObject definingMethodReference equals: traitDefinition.
	self
		assert: composedTraitObject class
		equals: GtLMissingTraitMethodDomainObject.
	self
		assert: composedTraitObject definingMethodReference
		equals: traitDefinition.
	^ userObject
]

{ #category : #examples }
GtLMethodReferenceTraitExamples >> conflictingTraitMethodReferenceMissingDomainObject [
	"Two traits that define the same method give the class a conflict instead of a method; the error names both trait methods"

	<gtExample>
	<return: #GtLMissingTraitConflictMethodDomainObject>
	^ GtLTraitMethodExamplesSubjects new
		during: [ :subjects | 
			| domainObject |
			domainObject := self
					resolveMethod: #traitMethod
					inClassNamed: subjects conflictingTraitsUser name
					classSide: false.
			self
				assert: domainObject class
				equals: GtLMissingTraitConflictMethodDomainObject.
			self assert: domainObject isErrorDomainObject.
			self assert: domainObject conflictLocationReference isNil.
			self
				assert: domainObject conflictingMethodReferences asArray
				equals: {GtLMethodReference fromCompiledMethod: subjects trait >> #traitMethod.
						GtLMethodReference
							fromCompiledMethod: subjects conflictingTrait >> #traitMethod}.
			self
				assert: domainObject errorMessage
				equals: ('{1}>>#traitMethod is not defined in its own class: it is provided by several traits that conflict ({2}>>#traitMethod, {3}>>#traitMethod). Define it in the class, or exclude it from all but one of the traits.'
						format: {subjects conflictingTraitsUser name.
								subjects trait name.
								subjects conflictingTrait name}).
			domainObject ]
]

{ #category : #examples }
GtLMethodReferenceTraitExamples >> conflictingTraitMethodReferenceMissingDomainObjectDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData conflictingReferences |
	domainObject := self conflictingTraitMethodReferenceMissingDomainObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.

	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: 'errorMessage') equals: domainObject errorMessage.
	self assert: (jsonData at: 'conflictLocationReference') isNil.
	conflictingReferences := jsonData at: 'conflictingMethodReferences'.
	self assert: conflictingReferences size equals: 2.
	conflictingReferences
		with: domainObject conflictingMethodReferences
		do: [ :aJsonReference :aReference | 
			self
				assert: (aJsonReference at: 'methodClassName')
				equals: aReference methodClassName asString.
			self assert: (aJsonReference at: 'methodName') equals: 'traitMethod'.
			self assert: (aJsonReference at: 'classSide') equals: false ].
	^ dataBlock
]

{ #category : #examples }
GtLMethodReferenceTraitExamples >> inheritedClassSideConflictingTraitMethodReferenceMissingDomainObject [
	"A class-side conflict inherited from a superclass names the class-side method of that superclass"

	<gtExample>
	<return: #GtLMissingTraitConflictMethodDomainObject>
	^ GtLTraitMethodExamplesSubjects new
		during: [ :subjects | 
			| domainObject |
			domainObject := self
					resolveMethod: #classTraitMethod
					inClassNamed: subjects conflictingTraitsUserSubclass name
					classSide: true.
			self
				assert: domainObject class
				equals: GtLMissingTraitConflictMethodDomainObject.
			self
				assert: domainObject conflictLocationReference methodClassName
				equals: subjects conflictingTraitsUser name asString.
			self assert: domainObject conflictLocationReference isClassSide.
			self
				assert: domainObject conflictingMethodReferences asArray
				equals: {GtLMethodReference
							fromCompiledMethod: subjects trait classSide >> #classTraitMethod.
						GtLMethodReference
							fromCompiledMethod: subjects conflictingTrait classSide >> #classTraitMethod}.
			domainObject ]
]

{ #category : #examples }
GtLMethodReferenceTraitExamples >> inheritedClassSideConflictingTraitMethodReferenceMissingDomainObjectDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject dataBlock jsonData conflictReference |
	domainObject := self
			inheritedClassSideConflictingTraitMethodReferenceMissingDomainObject.
	dataBlock := (domainObject llmDataViewsFor: GtLDataView new)
			serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.

	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: 'errorMessage') equals: domainObject errorMessage.
	conflictReference := jsonData at: 'conflictLocationReference'.
	self
		assert: (conflictReference at: 'methodClassName')
		equals: domainObject conflictLocationReference methodClassName asString.
	self assert: (conflictReference at: 'methodName') equals: 'classTraitMethod'.
	self assert: (conflictReference at: 'classSide') equals: true.
	self assert: (jsonData at: 'conflictingMethodReferences') size equals: 2.
	^ dataBlock
]

{ #category : #examples }
GtLMethodReferenceTraitExamples >> inheritedConflictingTraitMethodReferenceMissingDomainObject [
	"A conflict inherited from a superclass names the method of the superclass where the traits conflict"

	<gtExample>
	<return: #GtLMissingTraitConflictMethodDomainObject>
	^ GtLTraitMethodExamplesSubjects new
		during: [ :subjects | 
			| domainObject |
			domainObject := self
					resolveMethod: #traitMethod
					inClassNamed: subjects conflictingTraitsUserSubclass name
					classSide: false.
			self
				assert: domainObject class
				equals: GtLMissingTraitConflictMethodDomainObject.
			self
				assert: domainObject conflictLocationReference
				equals: (GtLMethodReference
						fromCompiledMethod: subjects conflictingTraitsUser >> #traitMethod).
			self assert: domainObject conflictingMethodReferences size equals: 2.
			self
				assert: domainObject errorMessage
				equals: ('{1}>>#traitMethod is not defined in its own class: it comes from {2}>>#traitMethod, where several traits conflict ({3}>>#traitMethod, {4}>>#traitMethod). Define it in the class, or resolve the conflict at {2}>>#traitMethod.'
						format: {subjects conflictingTraitsUserSubclass name.
								subjects conflictingTraitsUser name.
								subjects trait name.
								subjects conflictingTrait name}).
			domainObject ]
]

{ #category : #examples }
GtLMethodReferenceTraitExamples >> inheritedRequirementReferenceMissingDomainObject [
	"A requirement that a subclass inherits from a class using the trait is still reported as a requirement"

	<gtExample>
	<return: #GtLMissingRequiredTraitMethodDomainObject>
	^ GtLTraitMethodExamplesSubjects new
		during: [ :subjects | 
			| domainObject |
			domainObject := self
					resolveMethod: #requiredTraitMethod
					inClassNamed: subjects traitUserSubclass name
					classSide: false.
			self
				assert: domainObject class
				equals: GtLMissingRequiredTraitMethodDomainObject.
			self
				assert: domainObject definingMethodReference
				equals: (GtLMethodReference fromCompiledMethod: subjects trait >> #requiredTraitMethod).
			domainObject ]
]

{ #category : #examples }
GtLMethodReferenceTraitExamples >> inheritedTraitMethodReferenceMissingDomainObject [
	"A trait method inherited from a superclass names the trait method, not the copy in the superclass"

	<gtExample>
	<return: #GtLMissingInheritedMethodDomainObject>
	| domainObject |
	domainObject := self
			resolveMethod: #traitMethod
			inClassNamed: GtLExampleTraitUserSubclass name
			classSide: false.
	self assert: domainObject class equals: GtLMissingInheritedMethodDomainObject.
	self
		assert: domainObject definingMethodReference
		equals: (GtLMethodReference fromCompiledMethod: TGtLExampleTrait >> #traitMethod).
	self
		assert: domainObject errorMessage
		equals: 'GtLExampleTraitUserSubclass>>#traitMethod is not defined in its own class: it is inherited. Its source is TGtLExampleTrait>>#traitMethod'.
	^ domainObject
]

{ #category : #examples }
GtLMethodReferenceTraitExamples >> mixedConflictingTraitMethodReferenceMissingDomainObject [
	"When a trait method conflicts with a conflict of another used trait, the error names the methods of the traits that the class uses"

	<gtExample>
	<return: #GtLMissingTraitConflictMethodDomainObject>
	^ GtLTraitMethodExamplesSubjects new
		during: [ :subjects | 
			| domainObject |
			domainObject := self
					resolveMethod: #traitMethod
					inClassNamed: subjects mixedConflictUser name
					classSide: false.
			self
				assert: domainObject class
				equals: GtLMissingTraitConflictMethodDomainObject.
			self assert: domainObject conflictLocationReference isNil.
			self
				assert: domainObject conflictingMethodReferences asArray
				equals: {GtLMethodReference fromCompiledMethod: subjects otherTrait >> #traitMethod.
						GtLMethodReference
							fromCompiledMethod: subjects conflictingComposedTrait >> #traitMethod}.
			self
				assert: domainObject errorMessage
				equals: ('{1}>>#traitMethod is not defined in its own class: it is provided by several traits that conflict ({2}>>#traitMethod, {3}>>#traitMethod). Define it in the class, or exclude it from all but one of the traits.'
						format: {subjects mixedConflictUser name.
								subjects otherTrait name.
								subjects conflictingComposedTrait name}).
			domainObject ]
]

{ #category : #examples }
GtLMethodReferenceTraitExamples >> repeatedProviderConflictingTraitMethodReferenceMissingDomainObject [
	"Two used traits can provide the same trait method; the error names it once"

	<gtExample>
	<return: #GtLMissingTraitConflictMethodDomainObject>
	^ GtLTraitMethodExamplesSubjects new
		during: [ :subjects | 
			| domainObject |
			domainObject := self
					resolveMethod: #traitMethod
					inClassNamed: subjects repeatedProviderConflictUser name
					classSide: false.
			self
				assert: domainObject class
				equals: GtLMissingTraitConflictMethodDomainObject.
			self assert: domainObject conflictLocationReference isNil.
			self
				assert: domainObject conflictingMethodReferences asArray
				equals: {GtLMethodReference fromCompiledMethod: subjects trait >> #traitMethod.
						GtLMethodReference
							fromCompiledMethod: subjects conflictingTrait >> #traitMethod}.
			domainObject ]
]

{ #category : #examples }
GtLMethodReferenceTraitExamples >> repeatedRequirementReferenceMissingDomainObject [
	"A requirement that several classes in the hierarchy repeat is satisfied by the method that a class above them implements"

	<gtExample>
	<return: #GtLMissingInheritedMethodDomainObject>
	^ GtLTraitMethodExamplesSubjects new
		during: [ :subjects | 
			| domainObject |
			domainObject := self
					resolveMethod: #requiredTraitMethod
					inClassNamed: subjects requirementRepeatingSubclass name
					classSide: false.
			self
				assert: subjects requirementRepeatingSubclass new requiredTraitMethod
				equals: 45.
			self assert: domainObject class equals: GtLMissingInheritedMethodDomainObject.
			self
				assert: domainObject definingMethodReference
				equals: (GtLMethodReference
						fromCompiledMethod: subjects requirementImplementor >> #requiredTraitMethod).
			domainObject ]
]

{ #category : #examples }
GtLMethodReferenceTraitExamples >> requiredTraitMethodReferenceMissingDomainObject [
	"A method that a trait requires and the class does not implement"

	<gtExample>
	<return: #GtLMissingRequiredTraitMethodDomainObject>
	^ GtLTraitMethodExamplesSubjects new
		during: [ :subjects | 
			| domainObject |
			domainObject := self
					resolveMethod: #requiredTraitMethod
					inClassNamed: subjects traitUser name
					classSide: false.
			self
				assert: domainObject class
				equals: GtLMissingRequiredTraitMethodDomainObject.
			self
				assert: domainObject definingMethodReference
				equals: (GtLMethodReference fromCompiledMethod: subjects trait >> #requiredTraitMethod).
			self
				assert: domainObject errorMessage
				equals: ('{1}>>#requiredTraitMethod is not defined in its own class: it is required by a trait and not implemented. The requirement is declared in {2}>>#requiredTraitMethod; implement it in the class.'
						format: {subjects traitUser name.
								subjects trait name}).
			domainObject ]
]

{ #category : #examples }
GtLMethodReferenceTraitExamples >> requiringConflictingTraitMethodReferenceMissingDomainObject [
	"A required method, an explicit requirement or a subclass responsibility, gives way to the method of another trait, so a conflict that comes with that trait is named where it is"

	<gtExample>
	<return: #GtLMissingTraitConflictMethodDomainObject>
	^ GtLTraitMethodExamplesSubjects new
		during: [ :subjects | 
			| domainObject |
			domainObject := self
					resolveMethod: #traitMethod
					inClassNamed: subjects requiringConflictUser name
					classSide: false.
			self
				assert: domainObject class
				equals: GtLMissingTraitConflictMethodDomainObject.
			self
				assert: domainObject conflictLocationReference
				equals: (GtLMethodReference
						fromCompiledMethod: subjects conflictingComposedTrait >> #traitMethod).
			self
				assert: domainObject conflictingMethodReferences asArray
				equals: {GtLMethodReference fromCompiledMethod: subjects trait >> #traitMethod.
						GtLMethodReference
							fromCompiledMethod: subjects conflictingTrait >> #traitMethod}.
			domainObject ]
]

{ #category : #private }
GtLMethodReferenceTraitExamples >> resolveMethod: aSelector inClassNamed: aClassName classSide: aBoolean [
	^ (GtLMethodReference new
		methodClassName: aClassName;
		methodName: aSelector;
		classSide: aBoolean;
		yourself)
		compiledMethodIfPresent: [ :aMethod | aMethod ]
		ifMissing: [ :anErrorResult | anErrorResult ]
]

{ #category : #examples }
GtLMethodReferenceTraitExamples >> satisfiedRequirementReferenceMissingDomainObject [
	"A requirement that a superclass implements is reported as inherited from that superclass"

	<gtExample>
	<return: #GtLMissingInheritedMethodDomainObject>
	^ GtLTraitMethodExamplesSubjects new
		during: [ :subjects | 
			| domainObject |
			domainObject := self
					resolveMethod: #requiredTraitMethod
					inClassNamed: subjects requirementImplementorSubclass name
					classSide: false.
			self
				assert: subjects requirementImplementorSubclass new requiredTraitMethod
				equals: 45.
			self assert: domainObject class equals: GtLMissingInheritedMethodDomainObject.
			self
				assert: domainObject definingMethodReference
				equals: (GtLMethodReference
						fromCompiledMethod: subjects requirementImplementor >> #requiredTraitMethod).
			domainObject ]
]

{ #category : #examples }
GtLMethodReferenceTraitExamples >> traitMethodReference [
	"A method is found in the trait that defines it, on both sides"

	<gtExample>
	<return: #GtLMethodWithSource>
	| instanceSideReference classSideReference |
	instanceSideReference := GtLMethodReference new
			methodClassName: TGtLExampleTrait name;
			methodName: #traitMethod;
			classSide: false;
			yourself.
	classSideReference := GtLMethodReference new
			methodClassName: TGtLExampleTrait name;
			methodName: #classTraitMethod;
			classSide: true;
			yourself.
	self assert: instanceSideReference existsInImage.
	self
		assert: instanceSideReference compiledMethod
		equals: TGtLExampleTrait >> #traitMethod.
	self assert: classSideReference existsInImage.
	self
		assert: classSideReference compiledMethod
		equals: TGtLExampleTrait classSide >> #classTraitMethod.
	^ instanceSideReference
		methodObjectIfMissing: [ :anErrorResult | anErrorResult ]
]

{ #category : #examples }
GtLMethodReferenceTraitExamples >> traitProvidedMethodReferenceMissingDomainObject [
	"A reference to a method that the class gets from a trait is missing; the error names the trait method"

	<gtExample>
	<return: #GtLMissingTraitMethodDomainObject>
	| methodReference domainObject |
	methodReference := GtLMethodReference new
			methodClassName: GtLExampleTraitUser name;
			methodName: #traitMethod;
			classSide: false;
			yourself.
	self assert: (GtLExampleTraitUser includesSelector: #traitMethod).
	self assert: methodReference existsInImage not.
	self
		assert: ([ methodReference compiledMethod.
			false ] on: NotFound do: [ :anException | anException return: true ]).

	domainObject := methodReference
			compiledMethodIfPresent: [ :aMethod | aMethod ]
			ifMissing: [ :anErrorResult | anErrorResult ].
	self assert: domainObject class equals: GtLMissingTraitMethodDomainObject.
	self assert: domainObject isErrorDomainObject.
	self
		assert: domainObject definingMethodReference
		equals: (GtLMethodReference fromCompiledMethod: TGtLExampleTrait >> #traitMethod).
	self
		assert: domainObject errorMessage
		equals: 'GtLExampleTraitUser>>#traitMethod is not defined in its own class: it is provided by a trait. Its source is TGtLExampleTrait>>#traitMethod'.
	^ domainObject
]
