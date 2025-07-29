import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { Header } from './components/Header';
import { Dashboard } from './pages/Dashboard';
import { ContentGenerator } from './pages/ContentGenerator';
import { WorksheetCreator } from './pages/WorksheetCreator';
import { KnowledgeBase } from './pages/KnowledgeBase';
import { VisualAids } from './pages/VisualAids';
import { AudioAssessment } from './pages/AudioAssessment';
import { LessonPlanner } from './pages/LessonPlanner';
import { GameGenerator } from './pages/GameGenerator';
import { StudentProfiles } from './pages/StudentProfiles';
import { ContentExchange } from './pages/ContentExchange';
import { VoiceCommands } from './pages/VoiceCommands';

function App() {
  return (
    <Router>
      <div className="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50">
        <Header />
        <main className="container mx-auto px-4 py-8">
          <Routes>
            <Route path="/" element={<Dashboard />} />
            <Route path="/content-generator" element={<ContentGenerator />} />
            <Route path="/worksheet-creator" element={<WorksheetCreator />} />
            <Route path="/knowledge-base" element={<KnowledgeBase />} />
            <Route path="/visual-aids" element={<VisualAids />} />
            <Route path="/audio-assessment" element={<AudioAssessment />} />
            <Route path="/lesson-planner" element={<LessonPlanner />} />
            <Route path="/game-generator" element={<GameGenerator />} />
            <Route path="/student-profiles" element={<StudentProfiles />} />
            <Route path="/content-exchange" element={<ContentExchange />} />
            <Route path="/voice-commands" element={<VoiceCommands />} />
          </Routes>
        </main>
      </div>
    </Router>
  );
}

export default App;