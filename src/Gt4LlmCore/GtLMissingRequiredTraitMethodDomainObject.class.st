"
I am an error result for a method that a trait requires (with #explicitRequirement) and that the class using the trait does not implement. #definingMethodReference names the trait method that declares the requirement.
"
Class {
	#name : #GtLMissingRequiredTraitMethodDomainObject,
	#superclass : #GtLMissingLocalMethodDomainObject,
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLMissingRequiredTraitMethodDomainObject >> defaultErrorMessage [
	self definingMethodReference ifNil: [ ^ super defaultErrorMessage ].
	^ '{1} is not defined in its own class: it is {2}. The requirement is declared in {3}; implement it in the class.'
		format: {self missingObjectName.
				self reasonDescription.
				self definingMethodReference methodSignature}
]

{ #category : #accessing }
GtLMissingRequiredTraitMethodDomainObject >> reasonDescription [
	^ 'required by a trait and not implemented'
]
