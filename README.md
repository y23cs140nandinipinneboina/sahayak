# Sahayak - AI Teaching Assistant

An AI-powered teaching assistant designed to empower teachers in multi-grade, low-resource environments. Built with React, TypeScript, Tailwind CSS, and Supabase.

## Features

### 🎯 Core Functionality
- **Hyper-Local Content Generation**: Create culturally relevant content in local languages using Google's Gemini AI
- **Differentiated Worksheets**: Upload textbook pages and generate grade-appropriate worksheets
- **Instant Knowledge Base**: Get simple explanations for complex questions with local context
- **Visual Aids Generator**: Create blackboard-friendly diagrams and illustrations
- **Audio Reading Assessment**: Track student reading progress with AI-powered speech analysis
- **Lesson Planner**: Generate structured lesson plans for multi-grade classrooms
- **Educational Games**: Create engaging learning activities on-the-fly

### 🛠 Technical Stack
- **Frontend**: React 18, TypeScript, Tailwind CSS, Framer Motion
- **Backend**: Supabase (PostgreSQL, Authentication, Storage, Edge Functions)
- **AI Services**: Google Gemini API, Vertex AI Speech-to-Text
- **Deployment**: Netlify

## Getting Started

### Prerequisites
- Node.js 18+ and npm
- Supabase account
- Google AI API key

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd sahayak-teaching-assistant
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   ```
   
   Fill in your environment variables:
   ```env
   VITE_SUPABASE_URL=your_supabase_project_url
   VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
   VITE_GOOGLE_AI_API_KEY=your_google_ai_api_key
   ```

4. **Set up Supabase database**
   - Create a new Supabase project
   - Run the migration file: `supabase/migrations/create_initial_schema.sql`
   - This will create all necessary tables, RLS policies, and storage buckets

5. **Start the development server**
   ```bash
   npm run dev
   ```

## Database Setup

### Supabase Configuration

The application uses Supabase for:
- **Authentication**: Email/password authentication for teachers
- **Database**: PostgreSQL with Row Level Security (RLS)
- **Storage**: File uploads for audio assessments and images
- **Edge Functions**: Serverless functions for AI processing

### Database Schema

#### Core Tables:
- `teachers`: Teacher profiles and preferences
- `students`: Student information and progress tracking
- `generated_content`: AI-generated educational content
- `audio_assessments`: Reading assessment results
- `lesson_plans`: Structured lesson plans

#### Security:
- Row Level Security (RLS) enabled on all tables
- Teachers can only access their own data and students
- Secure file upload policies for different content types

### Setting up Supabase

1. **Create a new Supabase project** at [supabase.com](https://supabase.com)

2. **Run the database migration**:
   - Go to the SQL Editor in your Supabase dashboard
   - Copy and paste the contents of `supabase/migrations/create_initial_schema.sql`
   - Execute the migration

3. **Configure authentication**:
   - Go to Authentication > Settings
   - Disable email confirmation for development
   - Configure any additional auth providers if needed

4. **Set up storage buckets**:
   The migration automatically creates these buckets:
   - `audio-assessments`: For storing student reading recordings
   - `images`: For textbook pages and visual aids
   - `worksheets`: For generated worksheet files

## AI Services Integration

### Google Gemini API

The application integrates with Google's Gemini AI for:
- Content generation in multiple languages
- Multimodal analysis of textbook pages
- Question answering with cultural context

### Setup:
1. Get a Google AI API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Add it to your `.env` file as `VITE_GOOGLE_AI_API_KEY`

### Speech-to-Text (Future Enhancement)
- Integration with Google Cloud Speech-to-Text API
- Real-time audio analysis for reading assessments

## Backend Development

### API Structure

The application uses a combination of:
- **Supabase Client-side SDK**: Direct database operations with RLS
- **Edge Functions**: For complex AI processing and external API calls
- **Storage API**: For file uploads and management

### Key Backend Functions

#### Database Operations (`src/lib/database.ts`)
```typescript
// Authentication
signUp(email, password, userData)
signIn(email, password)
signOut()

// Teacher management
createTeacherProfile(teacherData)
getTeacherProfile(userId)
updateTeacherProfile(userId, updates)

// Student management
createStudent(studentData)
getStudentsByTeacher(teacherId)
updateStudent(studentId, updates)

// Content management
saveGeneratedContent(contentData)
getContentByTeacher(teacherId, contentType?)
```

#### AI Services (`src/lib/ai-services.ts`)
```typescript
// Content generation
generateContent(request: ContentGenerationRequest)
generateWorksheets(request: WorksheetGenerationRequest)
answerQuestion(question, language)

// Audio analysis
analyzeAudio(request: AudioAnalysisRequest)

// Visual aids
generateVisualAid(description, type)
```

### Adding New Features

1. **Database Changes**:
   - Create new migration files in `supabase/migrations/`
   - Update TypeScript types in `src/lib/supabase.ts`
   - Add corresponding functions in `src/lib/database.ts`

2. **AI Integration**:
   - Add new functions to `src/lib/ai-services.ts`
   - Handle API responses and error cases
   - Update UI components to use new services

3. **Authentication**:
   - All API calls automatically include user authentication
   - RLS policies ensure data security
   - Use `useAuthContext()` hook for user state

## Deployment

### Netlify Deployment

The application is configured for easy deployment to Netlify:

1. **Build the application**:
   ```bash
   npm run build
   ```

2. **Deploy to Netlify**:
   - Connect your repository to Netlify
   - Set environment variables in Netlify dashboard
   - Deploy automatically on git push

### Environment Variables for Production

Ensure these are set in your deployment environment:
```env
VITE_SUPABASE_URL=your_production_supabase_url
VITE_SUPABASE_ANON_KEY=your_production_supabase_anon_key
VITE_GOOGLE_AI_API_KEY=your_google_ai_api_key
```

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/new-feature`
3. Make your changes and test thoroughly
4. Commit your changes: `git commit -m 'Add new feature'`
5. Push to the branch: `git push origin feature/new-feature`
6. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue in the GitHub repository
- Check the documentation in the `/docs` folder
- Review the Supabase documentation for database-related questions

---

Built with ❤️ for teachers in multi-grade classrooms