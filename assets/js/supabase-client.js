// Supabase client — replace ANON_KEY with your actual anon key
const SUPABASE_URL = 'https://nmemmfblpzrkwyljpmvp.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5tZW1tZmJscHpya3d5bGpwbXZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzcxNDUzNzUsImV4cCI6MjA5MjcyMTM3NX0.iAEq-vnY481qdX0nmsonoDZWNFyFrao02GB_MS5BPzs';

const { createClient } = supabase;
window.sb = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
