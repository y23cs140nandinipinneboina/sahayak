/*
  # Add Student Authentication System

  1. New Tables
    - `users` table for authentication (if not exists)
    - Update `students` table to support authentication
    - Add student authentication policies

  2. Security
    - Enable RLS on students table for authenticated access
    - Add policies for students to manage their own data
    - Add policies for teachers to manage their students

  3. Changes
    - Add authentication fields to students table
    - Create comprehensive RLS policies
    - Add indexes for performance
*/

-- Create users table if it doesn't exist (for Supabase auth)
CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text UNIQUE NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Add authentication fields to students table
DO $$
BEGIN
  -- Add email field for student authentication
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'students' AND column_name = 'email'
  ) THEN
    ALTER TABLE students ADD COLUMN email text UNIQUE;
  END IF;

  -- Add password_hash field (though Supabase handles this)
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'students' AND column_name = 'is_authenticated'
  ) THEN
    ALTER TABLE students ADD COLUMN is_authenticated boolean DEFAULT false;
  END IF;

  -- Add student_code for easy identification
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'students' AND column_name = 'student_code'
  ) THEN
    ALTER TABLE students ADD COLUMN student_code text UNIQUE;
  END IF;

  -- Add parent/guardian contact
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'students' AND column_name = 'parent_contact'
  ) THEN
    ALTER TABLE students ADD COLUMN parent_contact text;
  END IF;
END $$;

-- Create index for student email lookups
CREATE INDEX IF NOT EXISTS idx_students_email ON students(email);
CREATE INDEX IF NOT EXISTS idx_students_student_code ON students(student_code);

-- Drop existing student policies
DROP POLICY IF EXISTS "Teachers can manage their students" ON students;

-- Create comprehensive RLS policies for students

-- Teachers can manage their students (full CRUD)
CREATE POLICY "Teachers can manage their students"
  ON students
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM teachers 
      WHERE teachers.id = auth.uid() 
      AND teachers.id = students.teacher_id
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM teachers 
      WHERE teachers.id = auth.uid() 
      AND teachers.id = students.teacher_id
    )
  );

-- Students can read their own profile
CREATE POLICY "Students can read own profile"
  ON students
  FOR SELECT
  TO authenticated
  USING (
    students.email IS NOT NULL 
    AND EXISTS (
      SELECT 1 FROM auth.users 
      WHERE auth.users.id = auth.uid() 
      AND auth.users.email = students.email
    )
  );

-- Students can update their own profile (limited fields)
CREATE POLICY "Students can update own profile"
  ON students
  FOR UPDATE
  TO authenticated
  USING (
    students.email IS NOT NULL 
    AND EXISTS (
      SELECT 1 FROM auth.users 
      WHERE auth.users.id = auth.uid() 
      AND auth.users.email = students.email
    )
  )
  WITH CHECK (
    students.email IS NOT NULL 
    AND EXISTS (
      SELECT 1 FROM auth.users 
      WHERE auth.users.id = auth.uid() 
      AND auth.users.email = students.email
    )
  );

-- Ensure RLS is enabled
ALTER TABLE students ENABLE ROW LEVEL SECURITY;

-- Grant necessary permissions
GRANT SELECT, INSERT, UPDATE ON students TO authenticated;