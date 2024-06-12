Class {
	#name : #GtOpenAIGtActionTutor,
	#superclass : #GtOpenAIActionTutor,
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #accessing }
GtOpenAIGtActionTutor >> instructions [
	^ format asInstruction
		addSection: (GtLlmInstructionSection new
				title: 'Actions';
				body: (GtLlmInstructionWithSections new
						introduction: 'All actions are listed below.';
						sections: (actions collect: #asInstruction)));
		addSection: self viewsDescription;
		addSection: self exampleViews
]
