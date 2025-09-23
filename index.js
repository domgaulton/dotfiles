#!/usr/bin/env node

import { intro, outro, select, spinner } from '@clack/prompts';
import { execSync } from 'child_process';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import fs from 'fs';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

async function main() {
  intro('🔧 Dotfiles Manager');

  const action = await select({
    message: 'What would you like to do?',
    options: [
      { value: 'dotfiles', label: 'Handle dotfiles' },
      { value: 'docker', label: 'Handle Docker' },
    ],
  });

  let subAction;
  if (action === 'dotfiles') {
    subAction = await select({
      message: 'What dotfiles action would you like to perform?',
      options: [
        { value: 'setup', label: 'Setup dotfiles (initial installation)' },
        { value: 'upgrade', label: 'Upgrade existing dotfiles' },
      ],
    });
  } else if (action === 'docker') {
    subAction = await select({
      message: 'What Docker action would you like to perform?',
      options: [
        { value: 'docker-build', label: 'Build Docker image' },
        { value: 'docker-start', label: 'Start Docker container' },
        { value: 'docker-run', label: 'Run Docker container interactively' },
        { value: 'docker-stop', label: 'Stop Docker container' },
      ],
    });
  }

  const s = spinner();
  const currentAction = subAction || action;

  switch (currentAction) {
    case 'setup':
      s.start('Running setup script...');
      try {
        const setupScript = join(__dirname, 'setup.sh');
        if (!fs.existsSync(setupScript)) {
          s.stop('❌ setup.sh not found');
          outro('Please ensure setup.sh exists in the dotfiles directory');
          process.exit(1);
        }

        execSync('chmod +x setup.sh && ./setup.sh', {
          stdio: 'inherit',
          cwd: __dirname
        });
        s.stop('✅ Setup completed successfully');
      } catch (error) {
        s.stop('❌ Setup failed');
        console.error(error.message);
        process.exit(1);
      }
      break;

    case 'upgrade':
      s.start('Running upgrade script...');
      try {
        const upgradeScript = join(__dirname, 'upgrade.sh');
        if (!fs.existsSync(upgradeScript)) {
          s.stop('❌ upgrade.sh not found');
          outro('Please ensure upgrade.sh exists in the dotfiles directory');
          process.exit(1);
        }

        execSync('chmod +x upgrade.sh && ./upgrade.sh', {
          stdio: 'inherit',
          cwd: __dirname
        });
        s.stop('✅ Upgrade completed successfully');
      } catch (error) {
        s.stop('❌ Upgrade failed');
        console.error(error.message);
        process.exit(1);
      }
      break;

    case 'docker-build':
      s.start('Building Docker image...');
      try {
        execSync('docker build -t dotfiles .', {
          stdio: 'inherit',
          cwd: __dirname
        });

        s.stop('✅ Docker image built successfully');
      } catch (error) {
        s.stop('❌ Failed to build Docker image');
        console.error(error.message);
        process.exit(1);
      }
      break;

    case 'docker-start':
      s.start('Starting Docker container...');
      try {
        // Remove existing container if it exists
        try {
          execSync('docker rm -f dotfiles-container', {
            stdio: 'pipe',
            cwd: __dirname
          });
        } catch {
          // Container doesn't exist, continue
        }

        execSync('docker run -d --name dotfiles-container dotfiles', {
          stdio: 'pipe',
          cwd: __dirname
        });

        s.stop('✅ Docker container started successfully');
      } catch (error) {
        s.stop('❌ Failed to start Docker container - Please ensure the image is built first');
        console.error(error.message);
        process.exit(1);
      }
      break;

    case 'docker-run':
      s.start('Running Docker container interactively...');
      try {
        s.stop('🚀 Starting interactive Docker container...');
        execSync('docker run -it --rm --name dotfiles-interactive dotfiles', {
          stdio: 'inherit',
          cwd: __dirname
        });
        outro('Interactive container finished');
        process.exit(0);
      } catch (error) {
        s.stop('❌ Failed to run Docker container interactively');
        console.error(error.message);
        process.exit(1);
      }
      break;

    case 'docker-stop':
      s.start('Stopping Docker container...');
      try {
        // Check if container exists first
        try {
          execSync('docker inspect dotfiles-container', {
            stdio: 'pipe',
            cwd: __dirname
          });
          // Container exists, stop and remove it
          execSync('docker stop dotfiles-container && docker rm dotfiles-container', {
            stdio: 'pipe',
            cwd: __dirname
          });
          s.stop('✅ Docker container stopped successfully');
        } catch {
          // Container doesn't exist
          s.stop('ℹ️  No container found to stop');
        }
      } catch (error) {
        s.stop('❌ Failed to stop Docker container');
        console.error(error.message);
        process.exit(1);
      }
      break;
  }

  outro('Done! 🎉');
  process.exit(0);
}

main().catch(console.error);