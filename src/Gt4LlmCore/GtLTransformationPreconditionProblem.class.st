"
I am a problem with what a transformation expects of the code, such as a class that exists or a name that is not used yet. My problems are checked against the image before the refactoring runs; later they may become preconditions of the refactoring, checked in its namespace. See {{gtMethod:GtLCodeTransformationSpecification>>#gtPreconditionProblemsAfterAdding:}}.
"
Class {
	#name : #GtLTransformationPreconditionProblem,
	#superclass : #GtLTransformationProblem,
	#category : #Gt4LlmCore
}
