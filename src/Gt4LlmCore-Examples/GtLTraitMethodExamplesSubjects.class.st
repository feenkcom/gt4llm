"
I install temporary traits and classes for examples that change trait code or need an invalid trait state, and remove them again. Read-only examples use the static subjects GtLExampleTraitUser, GtLExampleTraitUserSubclass and GtLExampleComposedTraitUser instead.

Each of my instances adds a random suffix to the names of its subjects, as GtPharoDummiesGenerator does for its packages, so examples that use me can run at the same time. Ask me for a subject (for example #traitUser) instead of naming it.

- trait defines #traitMethod, #requiredTraitMethod (an explicit requirement) and, on its class side, #classTraitMethod.
- composedTrait uses trait.
- conflictingTrait also defines #traitMethod and, on its class side, #classTraitMethod.
- conflictingComposedTrait uses trait and conflictingTrait, so it has the conflicts itself.
- requiringTrait requires #traitMethod; abstractTrait declares it a subclass responsibility; otherTrait defines another #traitMethod.
- traitUser uses trait, with #aliasedTraitMethod as an alias of #traitMethod.
- traitUserSubclass is a subclass of traitUser.
- composedTraitUser uses composedTrait.
- conflictingTraitsUser uses trait (with the alias #sequenceAliasedTraitMethod) and conflictingTrait, so #traitMethod and the class-side #classTraitMethod are conflicts; conflictingTraitsUserSubclass inherits them.
- conflictingComposedTraitUser uses conflictingComposedTrait, with #aliasedConflictingTraitMethod as an alias of #traitMethod.
- mixedConflictUser uses otherTrait and conflictingComposedTrait; requiringConflictUser uses requiringTrait, abstractTrait and conflictingComposedTrait; repeatedProviderConflictUser uses trait, conflictingTrait and composedTrait.
- requirementImplementor implements #requiredTraitMethod; its subclass requirementImplementorSubclass uses trait, so the requirement is satisfied; requirementRepeatingSubclass, a subclass of that one, uses trait again.

Use me with #during:, which removes exactly the subjects I installed, even if the block fails. I never remove a package.
"
Class {
	#name : #GtLTraitMethodExamplesSubjects,
	#superclass : #Object,
	#instVars : [
		'nameSuffix',
		'installedSubjects',
		'trait',
		'composedTrait',
		'conflictingTrait',
		'conflictingComposedTrait',
		'requiringTrait',
		'abstractTrait',
		'otherTrait',
		'traitUser',
		'traitUserSubclass',
		'composedTraitUser',
		'conflictingTraitsUser',
		'conflictingTraitsUserSubclass',
		'conflictingComposedTraitUser',
		'mixedConflictUser',
		'requiringConflictUser',
		'repeatedProviderConflictUser',
		'requirementImplementor',
		'requirementImplementorSubclass',
		'requirementRepeatingSubclass'
	],
	#category : #'Gt4LlmCore-Examples-Support'
}

{ #category : #accessing }
GtLTraitMethodExamplesSubjects >> composedTrait [
	^ composedTrait
]

{ #category : #accessing }
GtLTraitMethodExamplesSubjects >> composedTraitUser [
	^ composedTraitUser
]

{ #category : #accessing }
GtLTraitMethodExamplesSubjects >> conflictingComposedTrait [
	^ conflictingComposedTrait
]

{ #category : #accessing }
GtLTraitMethodExamplesSubjects >> conflictingComposedTraitUser [
	^ conflictingComposedTraitUser
]

{ #category : #accessing }
GtLTraitMethodExamplesSubjects >> conflictingTrait [
	^ conflictingTrait
]

{ #category : #accessing }
GtLTraitMethodExamplesSubjects >> conflictingTraitsUser [
	^ conflictingTraitsUser
]

{ #category : #accessing }
GtLTraitMethodExamplesSubjects >> conflictingTraitsUserSubclass [
	^ conflictingTraitsUserSubclass
]

{ #category : #api }
GtLTraitMethodExamplesSubjects >> during: aBlock [
	^ [ self install.
	aBlock value: self ] ensure: [ self uninstall ]
]

{ #category : #initialization }
GtLTraitMethodExamplesSubjects >> initialize [
	"A random suffix keeps the names of the subjects apart from those of another example that runs at the same time, as GtPharoDummiesGenerator does for its packages"

	super initialize.
	nameSuffix := (UUID new asString36 last: 8) capitalized.
	installedSubjects := OrderedCollection new
]

{ #category : #private }
GtLTraitMethodExamplesSubjects >> install [
	trait := self installTrait: 'TGtLTraitMethodExamplesSubject' composedOf: {}.
	trait compile: 'traitMethod ^ 42' classified: 'examples'.
	trait
		compile: 'requiredTraitMethod ^ self explicitRequirement'
		classified: 'examples'.
	trait classSide compile: 'classTraitMethod ^ 43' classified: 'examples'.
	composedTrait := self
			installTrait: 'TGtLTraitMethodExamplesComposedSubject'
			composedOf: trait.
	conflictingTrait := self
			installTrait: 'TGtLTraitMethodExamplesConflictingSubject'
			composedOf: {}.
	conflictingTrait compile: 'traitMethod ^ 44' classified: 'examples'.
	conflictingTrait classSide
		compile: 'classTraitMethod ^ 46'
		classified: 'examples'.
	conflictingComposedTrait := self
			installTrait: 'TGtLTraitMethodExamplesConflictingComposedSubject'
			composedOf: trait + conflictingTrait.
	requiringTrait := self
			installTrait: 'TGtLTraitMethodExamplesRequiringSubject'
			composedOf: {}.
	requiringTrait
		compile: 'traitMethod ^ self explicitRequirement'
		classified: 'examples'.
	abstractTrait := self
			installTrait: 'TGtLTraitMethodExamplesAbstractSubject'
			composedOf: {}.
	abstractTrait
		compile: 'traitMethod ^ self subclassResponsibility'
		classified: 'examples'.
	otherTrait := self
			installTrait: 'TGtLTraitMethodExamplesOtherSubject'
			composedOf: {}.
	otherTrait compile: 'traitMethod ^ 47' classified: 'examples'.
	traitUser := self
			installClass: 'GtLTraitMethodExamplesSubjectUser'
			subclassOf: Object
			using: trait @ {#aliasedTraitMethod -> #traitMethod}.
	traitUserSubclass := self
			installClass: 'GtLTraitMethodExamplesSubjectUserSubclass'
			subclassOf: traitUser
			using: {}.
	composedTraitUser := self
			installClass: 'GtLTraitMethodExamplesComposedSubjectUser'
			subclassOf: Object
			using: composedTrait.
	conflictingTraitsUser := self
			installClass: 'GtLTraitMethodExamplesConflictingSubjectsUser'
			subclassOf: Object
			using: trait @ {#sequenceAliasedTraitMethod -> #traitMethod}
					+ conflictingTrait.
	conflictingTraitsUserSubclass := self
			installClass: 'GtLTraitMethodExamplesConflictingSubjectsUserSubclass'
			subclassOf: conflictingTraitsUser
			using: {}.
	conflictingComposedTraitUser := self
			installClass: 'GtLTraitMethodExamplesConflictingComposedSubjectUser'
			subclassOf: Object
			using: conflictingComposedTrait
					@ {#aliasedConflictingTraitMethod -> #traitMethod}.
	mixedConflictUser := self
			installClass: 'GtLTraitMethodExamplesMixedConflictUser'
			subclassOf: Object
			using: otherTrait + conflictingComposedTrait.
	requiringConflictUser := self
			installClass: 'GtLTraitMethodExamplesRequiringConflictUser'
			subclassOf: Object
			using: requiringTrait + abstractTrait + conflictingComposedTrait.
	repeatedProviderConflictUser := self
			installClass: 'GtLTraitMethodExamplesRepeatedProviderConflictUser'
			subclassOf: Object
			using: trait + conflictingTrait + composedTrait.
	requirementImplementor := self
			installClass: 'GtLTraitMethodExamplesRequirementImplementor'
			subclassOf: Object
			using: {}.
	requirementImplementor
		compile: 'requiredTraitMethod ^ 45'
		classified: 'examples'.
	requirementImplementorSubclass := self
			installClass: 'GtLTraitMethodExamplesRequirementImplementorSubclass'
			subclassOf: requirementImplementor
			using: trait.
	requirementRepeatingSubclass := self
			installClass: 'GtLTraitMethodExamplesRequirementRepeatingSubclass'
			subclassOf: requirementImplementorSubclass
			using: trait
]

{ #category : #private }
GtLTraitMethodExamplesSubjects >> installClass: aBaseName subclassOf: aClass using: aTraitComposition [
	^ self
		installed: ((aClass << (self nameFor: aBaseName))
				traits: aTraitComposition;
				package: self packageName;
				install)
]

{ #category : #private }
GtLTraitMethodExamplesSubjects >> installTrait: aBaseName composedOf: aTraitComposition [
	^ self
		installed: ((Trait << (self nameFor: aBaseName))
				traits: aTraitComposition;
				package: self packageName;
				install)
]

{ #category : #private }
GtLTraitMethodExamplesSubjects >> installed: aClassOrTrait [
	installedSubjects add: aClassOrTrait.
	^ aClassOrTrait
]

{ #category : #accessing }
GtLTraitMethodExamplesSubjects >> mixedConflictUser [
	^ mixedConflictUser
]

{ #category : #private }
GtLTraitMethodExamplesSubjects >> nameFor: aBaseName [
	^ (aBaseName , nameSuffix) asSymbol
]

{ #category : #accessing }
GtLTraitMethodExamplesSubjects >> otherTrait [
	^ otherTrait
]

{ #category : #private }
GtLTraitMethodExamplesSubjects >> packageName [
	^ 'Gt4LlmCore-Examples'
]

{ #category : #accessing }
GtLTraitMethodExamplesSubjects >> repeatedProviderConflictUser [
	^ repeatedProviderConflictUser
]

{ #category : #accessing }
GtLTraitMethodExamplesSubjects >> requirementImplementor [
	^ requirementImplementor
]

{ #category : #accessing }
GtLTraitMethodExamplesSubjects >> requirementImplementorSubclass [
	^ requirementImplementorSubclass
]

{ #category : #accessing }
GtLTraitMethodExamplesSubjects >> requirementRepeatingSubclass [
	^ requirementRepeatingSubclass
]

{ #category : #accessing }
GtLTraitMethodExamplesSubjects >> requiringConflictUser [
	^ requiringConflictUser
]

{ #category : #accessing }
GtLTraitMethodExamplesSubjects >> requiringTrait [
	^ requiringTrait
]

{ #category : #accessing }
GtLTraitMethodExamplesSubjects >> trait [
	^ trait
]

{ #category : #accessing }
GtLTraitMethodExamplesSubjects >> traitUser [
	^ traitUser
]

{ #category : #accessing }
GtLTraitMethodExamplesSubjects >> traitUserSubclass [
	^ traitUserSubclass
]

{ #category : #private }
GtLTraitMethodExamplesSubjects >> uninstall [
	"Remove the users before the traits they use. Removing a class or trait leaves its name in Undeclared, so remove it there too"

	installedSubjects
		reverseDo: [ :aClassOrTrait | 
			| aName |
			aName := aClassOrTrait name.
			aClassOrTrait removeFromSystem.
			Undeclared removeKey: aName ifAbsent: [  ] ].
	installedSubjects removeAll
]
